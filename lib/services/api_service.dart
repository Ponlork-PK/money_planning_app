import 'package:flutter/material.dart';
import 'package:money_planning_app/models/category_model.dart';
import 'package:money_planning_app/models/dash_board_model.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final SupabaseClient client;

  Future<void> init() async {
    client = Supabase.instance.client;
  }

  // ----- AUTH -----
  GoTrueClient get auth => client.auth;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Session? get session => auth.currentSession;
  User? get user => auth.currentUser;



  // --------------- fetch dashboard totals ---------------
  String get uid {
    final u = client.auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.id;
  }

  /// Dashboard totals (Balance, Income, Expense)
  Future<DashboardModel> fetchDashboardSummary({String? currencyCode}) async {
    final res = await client.rpc(
      'get_dashboard_summary',
      params: {'p_currency': currencyCode},
    );

    // Supabase rpc can return Map or List depending on function,
    // with "returns table" it returns List with 1 row.
    if (res is List && res.isNotEmpty) {
      return DashboardModel.fromRpc(res.first as Map<String, dynamic>);
    }
    if (res is Map<String, dynamic>) {
      return DashboardModel.fromRpc(res);
    }
    return const DashboardModel(balance: 0, income: 0, expense: 0);
  }

  /// Recent transactions list
  Future<List<TransactionItemModel>> fetchAllTransactions() async {
    final data = await client
          .from('transactions')
          .select('id,type,amount,currency_code,transacted_at,item_name,categories(name)')
          .order('transacted_at', ascending: false) // ✅ newest first
          .order('created_at', ascending: false);    // ✅ tie-breaker if same date

    return (data as List)
        .map((e) => TransactionItemModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TransactionItemModel>> fetchRecentTransactionsToday() async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    final nowLocal = DateTime.now();
    final startLocal = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final endLocal = startLocal.add(const Duration(days: 1));

    final startUtc = startLocal.toUtc().toIso8601String();
    final endUtc = endLocal.toUtc().toIso8601String();

    final data = await client
        .from('transactions')
        .select('id,type,amount,currency_code,transacted_at,item_name,categories(name)')
        .eq('user_id', uid)
        .gte('transacted_at', startUtc)
        .lt('transacted_at', endUtc)
        .order('transacted_at', ascending: false)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => TransactionItemModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // Search transactions
  Future<List<TransactionItemModel>> searchTransactions({
    String? keyword,
    double? amount,
  }) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    var query = client
        .from('transactions')
        .select('id,user_id,type,amount,currency_code,transacted_at,item_name,note,payment_method_id,payment_methods(name)')
        .eq('user_id', uid);

    // ✅ name search (item_name OR note)
    final k = (keyword ?? '').trim();
    if (k.isNotEmpty) {
      query = query.or('item_name.ilike.%$k%,note.ilike.%$k%');
    }

    // ✅ exact amount search
    if (amount != null) {
      query = query.eq('amount', amount);
    }

    final data = await query
        .order('transacted_at', ascending: false)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => TransactionItemModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }


  // ---------- payment method resolver ----------
  Future<int?> _findPaymentMethodIdByName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final rows = await client
        .from('payment_methods')
        .select('id')
        .eq('user_id', uid)
        .ilike('name', trimmed)
        .maybeSingle();

    if (rows == null) return null;
    return rows['id'] as int;
  }

  Future<int?> _findOrCreatePaymentMethodId(String? paymentMethodName) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    final name = (paymentMethodName ?? '').trim();
    if (name.isEmpty) return null;

    final existingId = await _findPaymentMethodIdByName(name);
    if (existingId != null) return existingId;

    // create new payment method if not found
    final inserted = await client
        .from('payment_methods')
        .insert({'user_id': uid, 'name': name})
        .select('id')
        .single();

    return (inserted['id'] as num).toInt();
  }

  // ---------- CRUD ----------
  Future<TransactionItemModel> createTransaction(TransactionItemModel tx) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    final pmId = await _findOrCreatePaymentMethodId(tx.paymentMethodName);

    final data = await client
        .from('transactions')
        .insert(tx.toCreateMap(userId: uid, resolvedPaymentMethodId: pmId))
        .select('id,user_id,type,amount,currency_code,transacted_at,item_name,note,payment_method_id,payment_methods(name)')
        .single();

    return TransactionItemModel.fromMap(data);
  }

  Future<TransactionItemModel> updateTransaction(TransactionItemModel tx) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');
    if (tx.id == null) throw Exception('Transaction id is required for update');

    final pmId = await _findOrCreatePaymentMethodId(tx.paymentMethodName);

    final data = await client
        .from('transactions')
        .update(tx.toUpdateMap(resolvedPaymentMethodId: pmId))
        .eq('user_id', uid)
        .eq('id', tx.id!)
        .select('id,user_id,type,amount,currency_code,transacted_at,item_name,note,payment_method_id,payment_methods(name)')
        .single();

    return TransactionItemModel.fromMap(data);
  }

  Future<TransactionItemModel> getTransactionById(String id) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    final data = await client
        .from('transactions')
        .select('id,user_id,type,amount,currency_code,transacted_at,item_name,note,payment_method_id,payment_methods(name)')
        .eq('user_id', uid)
        .eq('id', id)
        .single();

    return TransactionItemModel.fromMap(data);
  }

  Future<void> deleteTransaction(int id) async {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');

    await client
        .from('transactions')
        .delete()
        .eq('user_id', uid)
        .eq('id', id);
  }


  // ---------------------------
  // Categories
  // ---------------------------
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final List<Map<String, dynamic>> rows = await client
          .from('categories')
          .select('id,user_id,name,icon,created_at,updated_at')
          .eq('user_id', uid)
          .order('name', ascending: true);

      return rows.map(CategoryModel.fromMap).toList();
    } catch (e) {
      debugPrint('fetchCategories error: $e');
      return [];
    }
  }


  // ---------------------------
  // Report: Transactions in period (join category + payment method)
  // ---------------------------
  Future<List<TransactionItemModel>> fetchTransactionsForReport({
    required DateTime fromLocal,
    required DateTime toLocal,
  }) async {
    final List<Map<String, dynamic>> rows = await client
        .from('transactions')
        .select(
          '''
          id,user_id,type,amount,currency_code,transacted_at,
          category_id,payment_method_id,item_name,note,created_at,updated_at,
          categories(id,name,icon),
          payment_methods(name)
          ''',
        )
        .eq('user_id', uid)
        .gte('transacted_at', fromLocal.toUtc().toIso8601String())
        .lte('transacted_at', toLocal.toUtc().toIso8601String())
        .order('transacted_at', ascending: false);

    return rows.map(TransactionItemModel.fromMap).toList();
  }

  // ✅ Top 5 (income + expense) by amount
  Future<List<TransactionItemModel>> fetchTop5TransactionsForReport({
    required DateTime fromLocal,
    required DateTime toLocal,
  }) async {
    final List<Map<String, dynamic>> rows = await client
        .from('transactions')
        .select(
          '''
          id,user_id,type,amount,currency_code,transacted_at,
          category_id,payment_method_id,item_name,note,created_at,updated_at,
          categories(id,name,icon),
          payment_methods(name)
          ''',
        )
        .eq('user_id', uid)
        .gte('transacted_at', fromLocal.toUtc().toIso8601String())
        .lte('transacted_at', toLocal.toUtc().toIso8601String())
        .order('amount', ascending: false)
        .limit(5);

    return rows.map(TransactionItemModel.fromMap).toList();
  }



  // =====================
  // LOANS API
  // =====================

  Future<List<Loan>> fetchLoans() async {
    final rowsRaw = await client
        .from('loans')
        .select('id,user_id,lender_type,lender_name,original_amount,interest_rate,term_months,start_date,end_date,currency_code,status,created_at')
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    final rows = List<Map<String, dynamic>>.from(rowsRaw);
    return rows.map(Loan.fromMap).toList();
  }

  Future<List<LoanPayment>> fetchPaymentsForLoans(List<String> loanIds) async {
    if (loanIds.isEmpty) return [];

    final rowsRaw = await client
        .from('loan_payments')
        .select('id,loan_id,payment_no,due_date,amount,currency_code,is_paid')
        .eq('user_id', uid)
        .inFilter('loan_id', loanIds)
        .order('loan_id', ascending: true)
        .order('payment_no', ascending: true);

    final rows = List<Map<String, dynamic>>.from(rowsRaw);
    return rows.map(LoanPayment.fromMap).toList();
  }

  Future<Loan> createLoan(Loan loan) async {
    final row = await client
        .from('loans')
        .insert(loan.toCreateMap(userId: uid))
        .select('id,user_id,lender_type,lender_name,original_amount,interest_rate,term_months,start_date,end_date,currency_code,status,created_at')
        .single();

    return Loan.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> createLoanPayments({
    required String loanId,
    required List<LoanPayment> payments,
  }) async {
    if (payments.isEmpty) return;

    final payload = payments
        .map((p) => p.toCreateMap(userId: uid, loanId: loanId))
        .toList();

    await client.from('loan_payments').insert(payload);
  }

  Future<void> markLoanPaymentPaid({
    required int paymentId,
    required bool isPaid,
  }) async {
    await client
        .from('loan_payments')
        .update({
          'is_paid': isPaid,
          'paid_at': isPaid ? DateTime.now().toUtc().toIso8601String() : null,
        })
        .eq('id', paymentId)
        .eq('user_id', uid);
  }

  Future<void> settleLoanEarly(String loanId) async {
    await client
        .from('loans')
        .update({'status': 'settled'})
        .eq('id', loanId)
        .eq('user_id', uid);
  }


  Future<void> updateLoan({
    required String loanId,
    required Loan loan,
  }) async {
    await client
        .from('loans')
        .update({
          'lender_type': loan.lenderType.toLowerCase().trim() == 'personal'
              ? 'family'
              : loan.lenderType.toLowerCase().trim(),
          'lender_name': loan.name,
          'original_amount': loan.originalAmount,
          'interest_rate': loan.interestRate,
          'term_months': loan.termMonths,
          'start_date': DateTime(loan.startDate.year, loan.startDate.month, loan.startDate.day)
              .toIso8601String(),
          'end_date': loan.endDate == null
              ? null
              : DateTime(loan.endDate!.year, loan.endDate!.month, loan.endDate!.day).toIso8601String(),
          'currency_code': loan.currencyCode.toUpperCase(),
        })
        .eq('id', loanId)
        .eq('user_id', uid);
  }


}