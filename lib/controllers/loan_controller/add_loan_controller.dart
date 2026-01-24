import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/services/api_service.dart';

class AddLoanController extends GetxController {
  final ApiService _api = ApiService();

  // mode
  final isEdit = false.obs;
  String? editingLoanId;

  // ui state
  final isSaving = false.obs;
  final error = RxnString();

  // dropdown + currency
  final selectedLoanType = 'bank'.obs; // bank | micro | family
  final currency = 'USD'.obs;

  // form controllers
  final lenderNameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final interestCtrl = TextEditingController();
  final termCtrl = TextEditingController();
  final purposeCtrl = TextEditingController();

  // dates
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();

    // if edit, expect argument Loan
    final arg = Get.arguments;
    if (arg is Loan) {
      _bindEdit(arg);
    } else if (arg is Map && arg['loan'] is Loan) {
      _bindEdit(arg['loan'] as Loan);
    }
  }

  @override
  void onClose() {
    lenderNameCtrl.dispose();
    amountCtrl.dispose();
    interestCtrl.dispose();
    termCtrl.dispose();
    purposeCtrl.dispose();
    super.onClose();
  }

  void _bindEdit(Loan loan) {
    isEdit.value = true;
    editingLoanId = loan.id;

    lenderNameCtrl.text = loan.name;
    amountCtrl.text = loan.originalAmount.toString();
    interestCtrl.text = loan.interestRate.toString(); // percent (ex: 1.5)
    termCtrl.text = loan.termMonths?.toString() ?? '';
    currency.value = loan.currencyCode.toUpperCase();

    // map label -> raw
    final t = loan.lenderType.toLowerCase().trim();
    if (t == 'bank') {selectedLoanType.value = 'bank';}
    else if (t == 'micro') {selectedLoanType.value = 'micro';}
    else {selectedLoanType.value = 'family';} // Personal/Family -> family

    startDate.value = loan.startDate;
    endDate.value = loan.endDate;
  }

  void setCurrency(String value) => currency.value = value;

  // picker
  Future<void> pickStartDate(BuildContext context) async {
    final initial = startDate.value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) startDate.value = picked;
  }

  Future<void> pickEndDate(BuildContext context) async {
    final initial = endDate.value ?? (startDate.value ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) endDate.value = picked;
  }

  // validate helpers
  double? _toDouble(String s) => double.tryParse(s.trim());
  int? _toInt(String s) => int.tryParse(s.trim());

  bool validate() {
    error.value = null;

    if (lenderNameCtrl.text.trim().isEmpty) {
      error.value = "Lender name is required";
      return false;
    }

    final amount = _toDouble(amountCtrl.text);
    if (amount == null || amount <= 0) {
      error.value = "Amount must be greater than 0";
      return false;
    }

    final rate = _toDouble(interestCtrl.text);
    if (rate != null && rate < 0) {
      error.value = "Interest rate cannot be negative";
      return false;
    }

    final term = _toInt(termCtrl.text);
    if (term != null && term <= 0) {
      error.value = "Term months must be > 0";
      return false;
    }

    if (startDate.value == null) {
      error.value = "Start date is required";
      return false;
    }

    // end date optional, but if provided must be >= start
    if (endDate.value != null &&
        endDate.value!.isBefore(startDate.value!)) {
      error.value = "End date must be after start date";
      return false;
    }

    return true;
  }

  // ✅ Save (create/update)
  Future<void> save() async {
    if (!validate()) {
      Get.snackbar("Invalid", error.value ?? "Please check inputs");
      return;
    }

    isSaving.value = true;
    error.value = null;

    try {
      final amount = _toDouble(amountCtrl.text)!;
      final rate = _toDouble(interestCtrl.text) ?? 0.0;
      final term = _toInt(termCtrl.text);

      // Create model (for insert)
      final draft = Loan(
        id: editingLoanId,
        userId: null,
        name: lenderNameCtrl.text.trim(),
        lenderType: selectedLoanType.value, // raw: bank|micro|family
        originalAmount: amount,
        currentBalance: amount,
        interestRate: rate,
        termMonths: term,
        startDate: startDate.value!,
        endDate: endDate.value,
        currencyCode: currency.value,
        paidPercent: 0,
        nextRepaymentDate: null,
        schedules: const [],
        histories: const [],
      );

      if (isEdit.value) {
        // ✅ update loan
        await _api.updateLoan(loanId: editingLoanId!, loan: draft);
      } else {
        // ✅ create loan
        final created = await _api.createLoan(draft);

        // ✅ optional: auto-generate schedule if termMonths exists
        if (term != null && term > 0) {
          final payments = _generateEqualMonthlyPayments(
            loanId: created.id!,
            currency: created.currencyCode,
            total: created.originalAmount,
            start: created.startDate,
            months: term,
          );
          await _api.createLoanPayments(loanId: created.id!, payments: payments);
        }
      }

      Get.back(result: true); // ✅ refresh previous screen
    } catch (e) {
      error.value = e.toString();
      Get.snackbar("Save failed", error.value!);
    } finally {
      isSaving.value = false;
    }
  }

  // Simple equal monthly schedule generator (can be improved later)
  List<LoanPayment> _generateEqualMonthlyPayments({
    required String loanId,
    required String currency,
    required double total,
    required DateTime start,
    required int months,
  }) {
    final per = total / months;
    final list = <LoanPayment>[];

    for (int i = 1; i <= months; i++) {
      final d = DateTime(start.year, start.month + i, start.day);
      list.add(
        LoanPayment(
          id: null,
          loanId: loanId,
          paymentNo: i,
          label: "Payment #$i",
          amount: per,
          date: d,
          currencyCode: currency,
          status: PaymentStatus.pending,
        ),
      );
    }
    return list;
  }
}
