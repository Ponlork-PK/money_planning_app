import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/api_service.dart';

class TransactionDetailController extends GetxController {
  final _api = ApiService();

  final transaction = Rxn<TransactionItemModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  String? txId;

  // ✅ Prepare these lists for List.generate
  final icons = <IconData>[].obs;
  final labels = <String>[].obs;
  final values = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is String) {
      txId = args;
      fetchTransaction();
      return;
    }
    error.value = 'Invalid transaction argument';
  }

  Future<void> fetchTransaction() async {
    final id = txId;
    if (id == null) return;

    try {
      isLoading.value = true;
      error.value = '';

      final tx = await _api.getTransactionById(id);
      transaction.value = tx;

      // ✅ build lists for UI
      _prepareDetailLists(tx);
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void _prepareDetailLists(TransactionItemModel tx) {
    final dateText = DateFormat('MMMM dd, yyyy').format(tx.transactedAt);

    final pm = (tx.paymentMethodName ?? '').trim();
    final note = (tx.note ?? '').trim();

    final tmpIcons = <IconData>[
      Icons.swap_horiz,                 // type
      Icons.calendar_today_outlined,    // date
      Icons.account_balance_wallet_outlined, // payment method
      Icons.attach_money,               // currency
      Icons.notes_outlined,             // note
    ];

    final tmpLabels = <String>[
      'txType'.tr,
      'txDate'.tr,
      'txPaymentMethod'.tr,
      'txCurrency'.tr,
      'txNote'.tr,
    ];

    final tmpValues = <String>[
      tx.type,
      dateText,
      pm.isEmpty ? '-' : pm,
      tx.currencyCode,
      note.isEmpty ? '-' : note,
    ];

    icons.assignAll(tmpIcons);
    labels.assignAll(tmpLabels);
    values.assignAll(tmpValues);
  }
}
