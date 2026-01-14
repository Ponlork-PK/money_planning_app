// loan_details_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/loans_model.dart';

class LoanDetailsController extends GetxController {

  late ScrollController scrollController;
  final isShowButtons = true.obs;

  final loan = Rxn<Loan>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLoan();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  Future<void> _loadLoan() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 400));
    final samplePayments = [
      LoanPayment(
        label: 'Payment #3',
        amount: 200.0,
        date: DateTime(2025, 7, 30),
        status: PaymentStatus.pending,
      ),
      LoanPayment(
        label: 'Payment #2',
        amount: 200.0,
        date: DateTime(2025, 7, 30),
        status: PaymentStatus.paid,
      ),
      LoanPayment(
        label: 'Payment #1',
        amount: 200.0,
        date: DateTime(2025, 7, 30),
        status: PaymentStatus.paid,
      ),
    ];

    loan.value = Loan(
      id: 001,
      name: 'Micro',
      currentBalance: 1000.0,
      originalAmount: 2500.0,
      interestRate: 0.015,
      termMonths: 12,
      startDate: DateTime(2025, 1, 6),
      endDate: DateTime(2025, 7, 2),
      paidPercent: 0.26,
      schedules: samplePayments,
      histories: samplePayments, // demo
    );

    isLoading.value = false;
  }

  void _onScroll(){
    if(scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if(isShowButtons.value) {
        isShowButtons.value = false;
      }
    } else{
      if(!isShowButtons.value) {
        isShowButtons.value = true;
      }
    }
  }

  void onSettleEarly() {
    // business logic or navigation
  }

  void onEditLoan() {
    // navigation to edit screen
  }
}





