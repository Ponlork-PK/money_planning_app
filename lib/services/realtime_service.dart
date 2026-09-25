import 'dart:async';
import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton that manages Supabase Realtime subscriptions.
///
/// Controllers register callbacks; when a DB change arrives on
/// the `transactions`, `loans`, or `loan_payments` tables the
/// matching callbacks fire so every screen stays in sync.
class RealtimeService {
  RealtimeService._internal();
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;

  RealtimeChannel? _transactionChannel;
  RealtimeChannel? _loanChannel;
  RealtimeChannel? _loanPaymentChannel;

  // --------------- callbacks ---------------
  final List<VoidCallback> _transactionListeners = [];
  final List<VoidCallback> _loanListeners = [];
  final List<VoidCallback> _loanPaymentListeners = [];

  // --------------- public API ---------------

  /// Call once after Supabase is initialised (e.g. in main.dart or ApiService.init).
  void init() {
    final client = Supabase.instance.client;

    // ── Transactions ──
    _transactionChannel = client.channel('public:${BaseConstants.tableTransactions}');
    _transactionChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: BaseConstants.tableTransactions,
          callback: (_) => _notifyAll(_transactionListeners),
        )
        .subscribe();

    // ── Loans ──
    _loanChannel = client.channel('public:${BaseConstants.tableLoans}');
    _loanChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: BaseConstants.tableLoans,
          callback: (_) => _notifyAll(_loanListeners),
        )
        .subscribe();

    // ── Loan Payments ──
    _loanPaymentChannel = client.channel('public:${BaseConstants.tableLoanPayments}');
    _loanPaymentChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: BaseConstants.tableLoanPayments,
          callback: (_) => _notifyAll(_loanPaymentListeners),
        )
        .subscribe();

    debugPrint('[RealtimeService] subscribed to ${BaseConstants.tableTransactions}, ${BaseConstants.tableLoans}, ${BaseConstants.tableLoanPayments}');
  }

  // ── Register / unregister listeners ──

  void addTransactionListener(VoidCallback cb) => _transactionListeners.add(cb);
  void removeTransactionListener(VoidCallback cb) => _transactionListeners.remove(cb);

  void addLoanListener(VoidCallback cb) => _loanListeners.add(cb);
  void removeLoanListener(VoidCallback cb) => _loanListeners.remove(cb);

  void addLoanPaymentListener(VoidCallback cb) => _loanPaymentListeners.add(cb);
  void removeLoanPaymentListener(VoidCallback cb) => _loanPaymentListeners.remove(cb);

  // ── Tear down ──

  Future<void> dispose() async {
    final client = Supabase.instance.client;
    if (_transactionChannel != null) {
      await client.removeChannel(_transactionChannel!);
    }
    if (_loanChannel != null) {
      await client.removeChannel(_loanChannel!);
    }
    if (_loanPaymentChannel != null) {
      await client.removeChannel(_loanPaymentChannel!);
    }
    _transactionListeners.clear();
    _loanListeners.clear();
    _loanPaymentListeners.clear();
  }

  // ── internal ──

  void _notifyAll(List<VoidCallback> listeners) {
    for (final cb in List<VoidCallback>.from(listeners)) {
      try {
        cb();
      } catch (e) {
        debugPrint('[RealtimeService] listener error: $e');
      }
    }
  }
}
