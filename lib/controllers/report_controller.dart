import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/category_model.dart';
import 'package:money_planning_app/models/transaction_item_model.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/services/realtime_service.dart';
import 'package:money_planning_app/services/report_pdf_service.dart';
import 'package:money_planning_app/utils/currency_converter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

enum ReportPeriod { daily, weekly, monthly }

class ReportController extends GetxController {
  final ApiService _api = ApiService();
  final ReportPdfService _pdfService = ReportPdfService();
  final RealtimeService _realtime = RealtimeService();
  final isExporting = false.obs;

  final selectedIndex = 0.obs; // 0 daily, 1 weekly, 2 monthly
  final isLoading = false.obs;
  final error = RxnString();

  final categories = <CategoryModel>[].obs;
  final transactions = <TransactionItemModel>[].obs;

  /// ✅ Top 5 (income + expense)
  final topTransactions = <TransactionItemModel>[].obs;

  ReportPeriod get period {
    final i = selectedIndex.value;
    if (i == 1) return ReportPeriod.weekly;
    if (i == 2) return ReportPeriod.monthly;
    return ReportPeriod.daily;
  }

  DateTime get _todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get fromDateLocal {
    final today = _todayStart;
    switch (period) {
      case ReportPeriod.daily:
        return today;
      case ReportPeriod.weekly:
        return today.subtract(const Duration(days: 6));
      case ReportPeriod.monthly:
        final now = DateTime.now();
        return DateTime(now.year, now.month, 1);
    }
  }

  DateTime get toDateLocal => DateTime.now();

  bool _isIncome(TransactionItemModel t) =>
      t.type.toLowerCase().trim() == 'income';

  bool _isExpense(TransactionItemModel t) =>
      t.type.toLowerCase().trim() == 'expense';

  // -------------------------
  // Totals — cross-currency (convert KHR → USD)
  // -------------------------
  double get incomeTotal => transactions
      .where((t) => _isIncome(t))
      .fold<double>(0.0, (sum, t) => sum + CurrencyConverter.toUsd(t.amount, t.currencyCode));

  double get expenseTotal => transactions
      .where((t) => _isExpense(t))
      .fold<double>(0.0, (sum, t) => sum + CurrencyConverter.toUsd(t.amount, t.currencyCode));

  // -------------------------
  // Expense by category
  // -------------------------
  Map<int, double> get expenseByCategory {
    final map = <int, double>{};
    for (final t in transactions.where(_isExpense)) {
      final cid = t.categoryId;
      if (cid == null) continue;
      map[cid] = (map[cid] ?? 0.0) + t.amount;
    }
    return map;
  }

  // -------------------------
  // Category helpers
  // -------------------------
  CategoryModel? categoryOfId(int? id) {
    if (id == null) return null;
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  String categoryName(int? id) =>
      categoryOfId(id)?.name ?? 'Other';

  // -------------------------
  // Colors for pie (no color column in DB)
  // stable deterministic palette by category id
  // -------------------------
  static const List<Color> _palette = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
    Colors.brown,
  ];

  Color colorOfCategory(int categoryId) =>
      _palette[categoryId.abs() % _palette.length];

  // -------------------------
  // Pie chart sections (expenses only)
  // -------------------------
  List<PieChartSectionData> get sections {
    final data = expenseByCategory;
    final total = data.values.fold<double>(0.0, (a, b) => a + b);

    if (total <= 0.0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey.shade300,
          title: "0%",
          radius: 45,
          titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ];
    }

    final out = <PieChartSectionData>[];

    // stable order by categories list
    for (final c in categories) {
      final cid = c.id;
      if (cid == null) continue;

      final value = data[cid] ?? 0.0;
      if (value <= 0.0) continue;

      final percent = (value / total) * 100.0;

      out.add(
        PieChartSectionData(
          value: value,
          color: colorOfCategory(cid),
          title: "${percent.toStringAsFixed(0)}%",
          radius: 45,
          titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      );
    }

    // fallback if categories missing but data exists
    if (out.isEmpty && data.isNotEmpty) {
      for (final e in data.entries) {
        final percent = (e.value / total) * 100.0;
        out.add(
          PieChartSectionData(
            value: e.value,
            color: colorOfCategory(e.key),
            title: "${percent.toStringAsFixed(0)}%",
            radius: 45,
            titleStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        );
      }
    }

    return out;
  }


  Future<void> exportPdf() async {
    if (isLoading.value) return;

    isExporting.value = true;
    try {
      // Ensure latest data for current period
      await loadReport();

      final bytes = await _pdfService.buildReportPdfBytes(
        title: "Money Planning Report",
        periodLabel: periodLabel,
        from: fromDateLocal,
        to: toDateLocal,
        categories: categories,
        expenseByCategory: expenseByCategory,
        allTransactions: transactions,
        categoryColor: pdfColorOfCategory,
      );

      final filename = "report_${periodLabel.toLowerCase()}.pdf";

      try {
        // ✅ best for mobile (share/save dialog)
        await Printing.sharePdf(bytes: bytes, filename: filename);
      } on MissingPluginException {
        // ✅ fallback for unsupported platforms (web/desktop/simulator issues)
        await Printing.layoutPdf(onLayout: (_) async => bytes, name: filename);
      }
    } catch (e) {
      Get.snackbar("Export failed", e.toString());
    } finally {
      isExporting.value = false;
    }
  }


  // -------------------------
  // Lifecycle / Load
  // -------------------------
  @override
  void onInit() {
    super.onInit();

    // Realtime: auto-refresh when transactions change
    _realtime.addTransactionListener(_onTransactionChange);

    // reload when period changes
    ever<int>(selectedIndex, (_) => loadReport());

    loadReport();
  }

  @override
  void onClose() {
    _realtime.removeTransactionListener(_onTransactionChange);
    super.onClose();
  }

  void _onTransactionChange() {
    debugPrint('[ReportController] realtime event → refreshing');
    loadReport();
  }

  void setIndex(int idx) => selectedIndex.value = idx;

  Future<void> loadReport() async {
    isLoading.value = true;
    error.value = null;

    try {
      final from = fromDateLocal;
      final to = toDateLocal;

      final cats = await _api.fetchCategories();
      categories.assignAll(cats);

      final txs = await _api.fetchTransactionsForReport(fromLocal: from, toLocal: to);
      transactions.assignAll(txs);

      final top = await _api.fetchTop5TransactionsForReport(fromLocal: from, toLocal: to);
      topTransactions.assignAll(top);
    } catch (e) {
      error.value = e.toString();
      categories.clear();
      transactions.clear();
      topTransactions.clear();
    } finally {
      isLoading.value = false;
    }
  }


  String get periodLabel {
    if (period == ReportPeriod.weekly) return "Weekly";
    if (period == ReportPeriod.monthly) return "Monthly";
    return "Daily";
  }

  PdfColor pdfColorOfCategory(int categoryId) {
    final c = colorOfCategory(categoryId); // your existing Color
    return PdfColor.fromInt(c.value);
  }

}
