import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
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

  // Cache raw transactions so we can recalculate on currency change
  List<TransactionItemModel> _cachedAll = [];

  @override
  void onInit() {
    super.onInit();
    _realtime.addTransactionListener(_onTransactionChange);

    // React when user changes default currency in Settings
    ever(SettingsController.to.selectedCurrency, (_) => _recalcSummary());

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

  /// Fetch all transactions and refresh both summary and recent list.
  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;

      _cachedAll = await _api.fetchAllTransactions();
      _recalcSummary();

      recent.assignAll(await _api.fetchRecentTransactionsToday());
    } catch (e) {
      debugPrint("refreshDashboard error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Recalculate income / expense / balance for the currently selected currency.
  void _recalcSummary() {
    final targetCurrency = SettingsController.to.selectedCurrency.value;

    double totalIncome = 0;
    double totalExpense = 0;

    for (final tx in _cachedAll) {
      final converted = CurrencyConverter.convert(
        tx.amount,
        tx.currencyCode,
        targetCurrency,
      );

      if (tx.isIncome) {
        totalIncome += converted;
      } else if (tx.isExpense) {
        totalExpense += converted;
      }
    }

    summary.value = DashboardModel(
      balance: totalIncome - totalExpense,
      income: totalIncome,
      expense: totalExpense,
    );
  }
}
