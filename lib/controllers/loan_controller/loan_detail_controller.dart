import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/services/api_service.dart';

class LoanDetailsController extends GetxController {
  final ApiService _api = ApiService();

  late ScrollController scrollController;
  final isShowButtons = true.obs;

  final loan = Rxn<Loan>();
  final payments = <LoanPayment>[].obs;

  final isLoading = false.obs;
  final error = RxnString();

  late final String loanId;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    // ✅ get loanId from navigation
    final arg = Get.arguments;
    final paramId = Get.parameters['id'];

    if (paramId != null && paramId.isNotEmpty) {
      loanId = paramId;
    } else if (arg is String && arg.isNotEmpty) {
      loanId = arg;
    } else if (arg is Map && (arg['loanId']?.toString().isNotEmpty ?? false)) {
      loanId = arg['loanId'].toString();
    } else {
      loanId = '';
    }

    loadLoanDetails();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadLoanDetails() async {
    if (loanId.isEmpty) {
      error.value = "Missing loan id";
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      // 1) fetch loan
      final all = await _api.fetchLoans();
      final found = all.firstWhere((l) => l.id == loanId, orElse: () => throw "Loan not found");
      // 2) fetch payments
      final payList = await _api.fetchPaymentsForLoans([loanId]);

      // sort by payment_no
      payList.sort((a, b) => a.paymentNo.compareTo(b.paymentNo));

      // compute summary
      final paid = payList.where((p) => p.isPaid).toList();
      final unpaid = payList.where((p) => !p.isPaid).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      final paidSum = paid.fold<double>(0.0, (s, p) => s + p.amount);
      final currentBalance = (found.originalAmount - paidSum) < 0 ? 0.0 : (found.originalAmount - paidSum);

      final paidPercent = found.originalAmount <= 0 ? 0.0 : (paidSum / found.originalAmount);
      final nextDate = unpaid.isEmpty ? null : unpaid.first.date;

      loan.value = found.copyWith(
        currentBalance: currentBalance,
        paidPercent: paidPercent,
        nextRepaymentDate: nextDate,
        schedules: unpaid,
        histories: paid,
      );

      payments.assignAll(payList);
    } catch (e) {
      error.value = e.toString();
      loan.value = null;
      payments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isShowButtons.value) isShowButtons.value = false;
    } else {
      if (!isShowButtons.value) isShowButtons.value = true;
    }
  }

  // ✅ toggle paid/unpaid
  Future<void> togglePaymentPaid(LoanPayment p) async {
    if (p.id == null) return;

    try {
      await _api.markLoanPaymentPaid(paymentId: p.id!, isPaid: !p.isPaid);
      await loadLoanDetails();
    } catch (e) {
      Get.snackbar("Update failed", e.toString());
    }
  }

  // ✅ settle early
  Future<void> onSettleEarly() async {
    if (loanId.isEmpty) return;

    try {
      await _api.settleLoanEarly(loanId);
      await loadLoanDetails();
      Get.snackbar("Success", "Loan settled");
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    }
  }

  void onEditLoan() {
    // Get.toNamed(RoutesName.editLoan, arguments: {"loanId": loanId});
  }

  // helpers for formatting
  String formatAmount(double v, String currency) {
    final cur = currency.toUpperCase().trim();
    if (cur == 'KHR') return v.toStringAsFixed(0);
    return v.toStringAsFixed(2);
  }
}
