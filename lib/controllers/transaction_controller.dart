import 'package:get/get.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/api_service.dart';

class TransactionTabController extends GetxController {
  final _api = ApiService();

  final isLoading = false.obs;
  final error = ''.obs;

  final transactions = <TransactionItemModel>[].obs;

  // summary by selected currency
  final currency = 'USD'.obs;
  final income = 0.0.obs;
  final expense = 0.0.obs;
  final balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
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

  void setCurrency(String c) {
    currency.value = c;
    _calcSummary();
  }

  void _calcSummary() {
    final cur = currency.value;

    double inc = 0;
    double exp = 0;

    for (final tx in transactions) {
      if (tx.currencyCode != cur) continue;

      if (tx.type == 'income') {
        inc += tx.amount;
      } else {
        exp += tx.amount;
      }
    }

    income.value = inc;
    expense.value = exp;
    balance.value = inc - exp;
  }
}
