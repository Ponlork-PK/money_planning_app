import 'package:get/get.dart';
import 'package:money_planning_app/screens/loans/add_loan_screen.dart';
import 'package:money_planning_app/screens/loans/loan_detail_screen.dart';
import 'package:money_planning_app/screens/transactions/add_transaction_screen.dart';
import 'package:money_planning_app/screens/transactions/search_transaction_screen.dart';
import 'package:money_planning_app/screens/transactions/transaction_detail_screen.dart';
import 'package:money_planning_app/utils/routes_name.dart';

import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';

List<GetPage<dynamic>>? getPages = [
  GetPage(name: RoutesName.login, page: ()=> LoginScreen()),
  GetPage(name: RoutesName.home, page: ()=> HomeScreen()),
  GetPage(name: RoutesName.searchTransaction, page: ()=> SearchTransactionScreen()),
  GetPage(name: RoutesName.addTransaction, page: ()=> AddTransactionScreen()),
  GetPage(name: RoutesName.addLoan, page: ()=> AddLoanScreen()),
  GetPage(name: RoutesName.loanDetail, page: ()=> LoanDetailsScreen()),
  GetPage(name: RoutesName.transactionDetail, page: ()=> TransactionDetailScreen()),
];