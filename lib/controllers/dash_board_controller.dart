import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/dash_board_model.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/realtime_service.dart';
import 'package:money_planning_app/utils/currency_converter.dart';
import '../services/api_service.dart';

class DashboardController extends GetxController {
  final ApiService _api = ApiService();
  final RealtimeService _realtime = RealtimeService();

  final isLoading = false.obs;

  final summary = const DashboardModel(balance: 0, income: 0, expense: 0).obs;
  final recent = <TransactionItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _realtime.addTransactionListener(_onTransactionChange);
    refreshDashboard();
  }

  @override
  void onClose() {
    _realtime.removeTransactionListener(_onTransactionChange);
    super.onClose();
  }

  void _onTransactionChange() {
    debugPrint('[DashboardController] realtime event → refreshing');
    refreshDashboard();
  }

  /// Fetch all transactions, convert to USD, and calculate totals client-side.
  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;

      // Fetch all transactions (both USD and KHR)
      final allTx = await _api.fetchAllTransactions();

      // Calculate income and expense by converting everything to USD
      double totalIncome = 0;
      double totalExpense = 0;

      for (final tx in allTx) {
        final amountInUsd = CurrencyConverter.toUsd(tx.amount, tx.currencyCode);

        if (tx.isIncome) {
          totalIncome += amountInUsd;
        } else if (tx.isExpense) {
          totalExpense += amountInUsd;
        }
      }

      summary.value = DashboardModel(
        balance: totalIncome - totalExpense,
        income: totalIncome,
        expense: totalExpense,
      );

      // Fetch today's recent transactions (unchanged)
      recent.assignAll(await _api.fetchRecentTransactionsToday());
    } catch (e) {
      debugPrint("refreshDashboard error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
