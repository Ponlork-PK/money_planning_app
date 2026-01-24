import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/dash_board_model.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import '../services/api_service.dart';

class DashboardController extends GetxController {
  final ApiService _api = ApiService();

  final isLoading = false.obs;

  // change this if you have dropdown later
  final currency = 'USD'.obs;

  final summary = const DashboardModel(balance: 0, income: 0, expense: 0).obs;
  final recent = <TransactionItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;

      summary.value = await _api.fetchDashboardSummary(currencyCode: currency.value);
      recent.assignAll(await _api.fetchRecentTransactionsToday());
    } catch (e) {
      debugPrint("refreshDashboard error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeCurrency(String code) async {
    currency.value = code;
    await refreshDashboard();
  }
}
