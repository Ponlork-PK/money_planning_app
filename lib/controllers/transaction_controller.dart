import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/services/realtime_service.dart';
import 'package:money_planning_app/utils/currency_converter.dart';

class TransactionTabController extends GetxController {
  final _api = ApiService();
  final _realtime = RealtimeService();

  final isLoading = false.obs;
  final error = ''.obs;

  final transactions = <TransactionItemModel>[].obs;

  // Summary — computed in the currently selected display currency
  final income = 0.0.obs;
  final expense = 0.0.obs;
  final balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _realtime.addTransactionListener(_onTransactionChange);

    // Recalculate on currency change without a new network request
    ever(SettingsController.to.selectedCurrency, (_) => _calcSummary());

    refreshTransactions();
  }

  @override
  void onClose() {
    _realtime.removeTransactionListener(_onTransactionChange);
    super.onClose();
  }

  void _onTransactionChange() {
    debugPrint('[TransactionTabController] realtime event → refreshing');
    refreshTransactions();
  }

  Future<void> refreshTransactions() async {
    try {
      isLoading.value = true;
      error.value = '';

      final list = await _api.fetchAllTransactions();
      transactions.assignAll(list);

      _calcSummary();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculate summary, converting each transaction to the currently selected currency.
  void _calcSummary() {
    final targetCurrency = SettingsController.to.selectedCurrency.value;

    double inc = 0;
    double exp = 0;

    for (final tx in transactions) {
      final converted = CurrencyConverter.convert(
        tx.amount,
        tx.currencyCode,
        targetCurrency,
      );

      if (tx.isIncome) {
        inc += converted;
      } else if (tx.isExpense) {
        exp += converted;
      }
    }

    income.value = inc;
    expense.value = exp;
    balance.value = inc - exp;
  }
}
