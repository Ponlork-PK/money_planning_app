import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/api_service.dart';

class SearchTransactionController extends GetxController {
  final _api = ApiService();

  final searchCtrl = TextEditingController();

  final isLoading = false.obs;
  final error = ''.obs;
  final results = <TransactionItemModel>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    searchCtrl.addListener(() {
      final text = searchCtrl.text;
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 350), () {
        search(text);
      });
    });
  }

  // --- parsing helpers ---
  double? _tryParseAmount(String input) {
    final cleaned = input.trim().replaceAll(',', '');
    if (cleaned.isEmpty) return null;
    final v = double.tryParse(cleaned);
    if (v == null) return null;

    // optional: normalize to 2 decimals to match stored values
    return double.parse(v.toStringAsFixed(2));
  }

  ({String keyword, double? amount}) _parseQuery(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return (keyword: '', amount: null);

    final parts = text.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

    double? amount;
    final keywordParts = <String>[];

    for (final p in parts) {
      final a = _tryParseAmount(p);
      if (a != null && amount == null) {
        amount = a;
      } else {
        keywordParts.add(p);
      }
    }

    return (keyword: keywordParts.join(' ').trim(), amount: amount);
  }

  Future<void> search(String input) async {
    final parsed = _parseQuery(input);

    // empty => clear
    if (parsed.keyword.isEmpty && parsed.amount == null) {
      results.clear();
      error.value = '';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final list = await _api.searchTransactions(
        keyword: parsed.keyword.isEmpty ? null : parsed.keyword,
        amount: parsed.amount,
      );

      results.assignAll(list);
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.onClose();
  }
}
