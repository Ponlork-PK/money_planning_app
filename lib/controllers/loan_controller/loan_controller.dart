import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/loans_model.dart';

class LoanController extends GetxController {

  late ScrollController scrollController;

  final isShowButtons = true.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  final loans = <Loan>[
    Loan(
      id: 001,
      name: "ACLIDA Bank",
      lenderType: "Bank",
      originalAmount: 1000.00,
      nextRepaymentDate: DateTime.now(),
      paidPercent: 0.28, // 28%
    ),
    Loan(
      id: 002,
      name: "ABA Bank",
      lenderType: "Bank",
      originalAmount: 1000.00,
      nextRepaymentDate: DateTime.now(),
      paidPercent: 0.90,
    ),
    Loan(
      id: 003,
      name: "Hattha Bank",
      lenderType: "Bank",
      originalAmount: 1000.00,
      nextRepaymentDate: DateTime.now(),
      paidPercent: 0.50,
    ),
    Loan(
      id: 004,
      name: "Micro Finance",
      lenderType: "Micro",
      originalAmount: 1000.00,
      nextRepaymentDate: DateTime.now(),
      paidPercent: 0.40,
    ),
    Loan(
      id: 005,
      name: "Family",
      lenderType: "Personal",
      originalAmount: 1000.00,
      nextRepaymentDate: DateTime.now(),
      paidPercent: 0.30,
    ),
    Loan(
      id: 006,
      name: "ACLIDA Bank",
      lenderType: "Bank",
      originalAmount: 1000.00,
      nextRepaymentDate: DateTime.now(),
      paidPercent: 0.15,
    ),
  ].obs;
  List<Loan> get filterdLoan {
    switch(selectedIndex.value){
      case 1:
        return loans.where((loan) => loan.lenderType == "Bank").toList();
      case 2:
        return loans.where((loan) => loan.lenderType == "Micro").toList();
      case 3:
        return loans.where((loan) => loan.lenderType == "Personal").toList();
      default:
        return loans;
    }
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
