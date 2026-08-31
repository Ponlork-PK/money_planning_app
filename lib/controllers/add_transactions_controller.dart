import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class AddTransactionsController extends GetxController {
  final ApiService _api = ApiService();

  // ===== Mode =====
  final isEdit = false.obs;
  String? editingId; // UUID string

  // ===== UI state =====
  final selectedTransactionType = 0.obs; // 0 income, 1 expense
  bool get isExpense => selectedTransactionType.value == 1;

  final currencies = <String>['USD', 'KHR'].obs;
  final selectedCurrency = 'USD'.obs;

  // Date
  final Rxn<DateTime> selectedDate = Rxn<DateTime>(DateTime.now());

  String get label {
    final d = selectedDate.value;
    if (d == null) return "Select Date";
    return DateFormat('MMMM dd, yyyy').format(d);
  }

  // ===== Form controllers =====
  final amountCtrl = TextEditingController();
  final purposeCtrl = TextEditingController();
  final itemNameCtrl = TextEditingController();
  final paymentMethodCtrl = TextEditingController();

  // Save state
  final isSaving = false.obs;

  // ===== Actions =====
  void setIndex(int v) {
    selectedTransactionType.value = v;

    // ✅ if switching to income, clear expense-only inputs
    if (v == 0) {
      itemNameCtrl.clear();
      paymentMethodCtrl.clear();
    }
  }

  void setCurrency(String v) => selectedCurrency.value = v;

  @override
  void onInit() {
    super.onInit();

    _resetForm(); // ✅ prevent old state leaking

    final args = Get.arguments;

    // ✅ Edit mode (best): pass full TransactionModel from detail
    if (args is TransactionItemModel) {
      _loadForEdit(args);
      return;
    }

    // ✅ Optional: if someone passes only id
    if (args is String && args.isNotEmpty) {
      isEdit.value = true;
      editingId = args;
      _loadFromBackendForEdit(args);
      return;
    }
  }

  void _resetForm() {
    isEdit.value = false;
    editingId = null;

    selectedTransactionType.value = 0;
    selectedCurrency.value = 'USD';
    selectedDate.value = DateTime.now();

    amountCtrl.clear();
    purposeCtrl.clear();
    itemNameCtrl.clear();
    paymentMethodCtrl.clear();
  }

  Future<void> _loadFromBackendForEdit(String id) async {
    try {
      isSaving.value = true;
      final tx = await _api.getTransactionById(id); // must accept String UUID
      _loadForEdit(tx);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSaving.value = false;
    }
  }

  void _loadForEdit(TransactionItemModel tx) {
    isEdit.value = true;
    editingId = tx.id;

    selectedTransactionType.value = tx.type == 'expense' ? 1 : 0;
    selectedCurrency.value = tx.currencyCode;
    selectedDate.value = tx.transactedAt;

    amountCtrl.text = tx.amount.toStringAsFixed(2);
    purposeCtrl.text = tx.note ?? '';
    itemNameCtrl.text = tx.itemName ?? '';
    paymentMethodCtrl.text = tx.paymentMethodName ?? '';
  }

  Future<void> opendDatePicker([BuildContext? context]) async {
    final ctx = context ?? Get.context!;
    final now = DateTime.now();
    final initial = selectedDate.value ?? now;
    final isDark = Theme.of(ctx).brightness == Brightness.dark;

    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: BaseColors.primary,
                    surface: BaseColors.black,
                    onSurface: BaseColors.white,
                  )
                : const ColorScheme.light(
                    primary: BaseColors.primary,
                    surface: BaseColors.white,
                    onSurface: BaseColors.black,
                  ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark ? BaseColors.darkCard : BaseColors.white,
              headerBackgroundColor: BaseColors.primary,
              headerForegroundColor: BaseColors.white,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) selectedDate.value = picked;
  }

  double _parseAmount() {
    final raw = amountCtrl.text.trim().replaceAll(',', '');
    final v = double.tryParse(raw);
    if (v == null || v <= 0) throw Exception('Please input valid amount');
    return v;
  }

  void _validate() {
    _parseAmount();

    if (selectedDate.value == null) {
      throw Exception('Please select date');
    }

    if (isExpense) {
      if (itemNameCtrl.text.trim().isEmpty) {
        throw Exception('Item name is required for Expense');
      }
      if (paymentMethodCtrl.text.trim().isEmpty) {
        throw Exception('Payment method is required for Expense');
      }
    }
  }

  Future<void> submit() async {
    try {
      isSaving.value = true;
      _validate();

      if (isEdit.value && (editingId == null || editingId!.isEmpty)) {
        throw Exception('Missing transaction id for update');
      }

      final tx = TransactionItemModel(
        id: isEdit.value ? editingId : null,
        type: isExpense ? 'expense' : 'income',
        amount: _parseAmount(),
        currencyCode: selectedCurrency.value,
        transactedAt: selectedDate.value!,
        itemName: isExpense ? itemNameCtrl.text.trim() : null,
        note: purposeCtrl.text.trim().isEmpty ? null : purposeCtrl.text.trim(),
        paymentMethodName: isExpense ? paymentMethodCtrl.text.trim() : null,
      );

      if (isEdit.value) {
        await _api.updateTransaction(tx);
      } else {
        await _api.createTransaction(tx);
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    purposeCtrl.dispose();
    itemNameCtrl.dispose();
    paymentMethodCtrl.dispose();
    super.onClose();
  }
}
