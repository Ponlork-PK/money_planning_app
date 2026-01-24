import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/services/api_service.dart';

class LoanController extends GetxController {
  final ApiService _api = ApiService();

  late ScrollController scrollController;

  final isShowButtons = true.obs;
  final selectedIndex = 0.obs;

  final isLoading = false.obs;
  final error = RxnString();

  final loans = <Loan>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    ever<int>(selectedIndex, (_) {
      // UI filter only; no API call needed
    });

    loadLoans();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void setIndex(int idx) => selectedIndex.value = idx;

  List<Loan> get filteredLoan {
    final idx = selectedIndex.value;

    bool match(Loan l, String want) =>
        l.lenderType.toLowerCase() == want.toLowerCase() ||
        (want.toLowerCase() == 'family' && l.lenderType.toLowerCase() == 'personal');

    switch (idx) {
      case 1:
        return loans.where((l) => match(l, 'Bank')).toList();
      case 2:
        return loans.where((l) => match(l, 'Micro')).toList();
      case 3:
        return loans.where((l) => match(l, 'Family')).toList();
      default:
        return loans;
    }
  }

  Future<void> loadLoans() async {
    isLoading.value = true;
    error.value = null;

    try {
      final baseLoans = await _api.fetchLoans();
      final ids = baseLoans.map((e) => e.id).whereType<String>().toList();

      final payments = await _api.fetchPaymentsForLoans(ids);

      // group payments by loan_id
      final map = <String, List<LoanPayment>>{};
      for (final p in payments) {
        final lid = p.loanId;
        if (lid == null) continue;
        map.putIfAbsent(lid, () => []).add(p);
      }

      final updated = baseLoans.map((loan) {
        final lid = loan.id ?? '';
        final list = map[lid] ?? const <LoanPayment>[];

        final paid = list.where((p) => p.isPaid).toList();
        final unpaid = list.where((p) => !p.isPaid).toList()
          ..sort((a, b) => a.date.compareTo(b.date));

        final paidSum = paid.fold<double>(0.0, (s, p) => s + p.amount);
        final currentBalance = (loan.originalAmount - paidSum) < 0 ? 0.0 : (loan.originalAmount - paidSum);

        final paidPercent = loan.originalAmount <= 0 ? 0.0 : (paidSum / loan.originalAmount);

        final nextRepay = unpaid.isEmpty ? null : unpaid.first.date;

        return loan.copyWith(
          currentBalance: currentBalance,
          paidPercent: paidPercent,
          nextRepaymentDate: nextRepay,
          schedules: unpaid,
          histories: paid,
        );
      }).toList();

      loans.assignAll(updated);
    } catch (e) {
      error.value = e.toString();
      loans.clear();
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
}






// import 'package:get/get.dart';
// import 'package:money_planning_app/models/loans_model.dart';
// import 'package:money_planning_app/services/api_service.dart';

// class LoanController extends GetxController {
//   final apiService = ApiService();

//   final loans = <LoanModel>[].obs;
//   final loanTypes = <Map<String, dynamic>>[].obs;
//   final selectedLoan = Rxn<LoanModel>();
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadLoans();
//     loadLoanTypes();
//     watchLoansRealtime();
//   }

//   Future<void> loadLoans({String? status}) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await apiService.getLoans(status: status);
//       if (response.success) {
//         loans.value = response.data ?? [];
//       } else {
//         errorMessage.value = response.message ?? 'Failed to load loans';
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> loadLoanDetails(String loanId) async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.getLoanDetails(loanId);
//       if (response.success) {
//         selectedLoan.value = response.data;
//         return true;
//       }
//       errorMessage.value = response.message ?? 'Failed to load loan details';
//       return false;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadLoanTypes() async {
//     try {
//       final response = await apiService.getLoanTypes();
//       if (response.success) {
//         loanTypes.value = response.data ?? [];
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     }
//   }

//   Future<bool> createLoan({
//     required String loanTypeId,
//     required String lenderName,
//     required double originalAmount,
//     required String currency,
//     required double interestRate,
//     required int loanTermMonths,
//     required DateTime startDate,
//     String? purpose,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final response = await apiService.createLoan(
//         loanTypeId: loanTypeId,
//         lenderName: lenderName,
//         originalAmount: originalAmount,
//         currency: currency,
//         interestRate: interestRate,
//         loanTermMonths: loanTermMonths,
//         startDate: startDate,
//         purpose: purpose,
//       );

//       if (response.success) {
//         loans.insert(0, response.data!);
//         return true;
//       } else {
//         errorMessage.value = response.message ?? 'Failed to create loan';
//         return false;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> recordPayment({
//     required String paymentId,
//     required DateTime paymentDate,
//   }) async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.recordPayment(
//         paymentId: paymentId,
//         paymentDate: paymentDate,
//       );

//       if (response.success) {
//         return true;
//       }
//       errorMessage.value = response.message ?? 'Payment recording failed';
//       return false;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<bool> settleLoan(String loanId) async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.settleLoan(loanId);
//       if (response.success) {
//         await loadLoans();
//         return true;
//       }
//       errorMessage.value = response.message ?? 'Settlement failed';
//       return false;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void watchLoansRealtime() {
//     apiService.watchLoans().listen((data) {
//       loans.value = data;
//     });
//   }
// }
