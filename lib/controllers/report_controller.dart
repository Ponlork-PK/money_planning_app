import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/models/report_model.dart';
import 'package:money_planning_app/utils/base_colors.dart';

enum ReportPeriod { daily, weekly, monthly }

class ReportController extends GetxController {
  final selectedIndex = 0.obs;
  final transactions = <TxModel>[].obs;

  // ✅ FIX: make IDs match your TxModel.categoryId values
  final categories = const <CategoryModel>[
    CategoryModel(id: "salary", name: "Salary", color: BaseColors.income), // ✅ added
    CategoryModel(id: "loan", name: "Loan", color: Colors.orange),
    CategoryModel(id: "food", name: "Food", color: Colors.redAccent),
    CategoryModel(id: "transport", name: "Transport", color: Colors.blue),
    CategoryModel(id: "shopping", name: "Shopping", color: Colors.purple),
    CategoryModel(id: "another", name: "Another", color: BaseColors.income), // ✅ fixed spelling/id
  ];

  // ---------- Period helpers ----------
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

  DateTime get _fromDate {
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

  List<TxModel> get periodTxs {
    final from = _fromDate;
    return transactions.where((t) => !t.date.isBefore(from)).toList();
  }

  // ---------- Totals ----------
  double get incomeTotal => periodTxs
      .where((t) => t.type == TxType.income)
      .fold<double>(0.0, (sum, t) => sum + t.amount);

  double get expenseTotal => periodTxs
      .where((t) => t.type == TxType.expense)
      .fold<double>(0.0, (sum, t) => sum + t.amount);

  // ---------- Spending by category (expenses only) ----------
  Map<String, double> get expenseByCategory {
    final map = <String, double>{};
    for (final t in periodTxs.where((t) => t.type == TxType.expense)) {
      map[t.categoryId] = (map[t.categoryId] ?? 0.0) + t.amount;
    }
    return map;
  }

  // ---------- Pie chart sections ----------
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

    // stable order based on categories list
    for (final c in categories) {
      final value = data[c.id] ?? 0.0;
      if (value <= 0.0) continue;

      final percent = (value / total) * 100.0;
      out.add(
        PieChartSectionData(
          value: value,
          color: c.color,
          title: "${percent.toStringAsFixed(0)}%",
          radius: 45,
          titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      );
    }

    // ✅ If your expense categories are not in `categories`, still show them
    // (optional safety)
    if (out.isEmpty && data.isNotEmpty) {
      for (final e in data.entries) {
        final percent = (e.value / total) * 100.0;
        out.add(PieChartSectionData(
          value: e.value,
          color: Colors.grey,
          title: "${percent.toStringAsFixed(0)}%",
          radius: 45,
          titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ));
      }
    }

    return out;
  }

  // ---------- Top transactions (top 5 expenses) ----------
  List<TxModel> get topExpenses {
    final list = periodTxs.where((t) => t.type == TxType.expense).toList();
    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list.take(5).toList();
  }

  CategoryModel categoryOf(String id) => categories.firstWhere(
        (c) => c.id == id,
        orElse: () => const CategoryModel(
          id: "other",
          name: "Other",
          color: Colors.grey,
        ),
      );

  @override
  void onInit() {
    super.onInit();
    _seedDummyData();
  }

  void setIndex(int idx) => selectedIndex.value = idx;

  void setTransactions(List<TxModel> items) => transactions.assignAll(items);
  void addTransaction(TxModel item) => transactions.add(item);

  void _seedDummyData() {
    final now = DateTime.now();
    transactions.assignAll([
      TxModel(
        id: "1",
        title: "Salary",
        amount: 1200,
        type: TxType.income,
        categoryId: "salary", // ✅ now exists in categories
        date: now.subtract(const Duration(days: 2)),
      ),
      TxModel(
        id: "2",
        title: "Loan",
        amount: 40,
        type: TxType.expense,
        categoryId: "loan",
        date: now,
      ),
      TxModel(
        id: "3",
        title: "Lunch",
        amount: 8,
        type: TxType.expense,
        categoryId: "food",
        date: now.subtract(const Duration(days: 1)),
      ),
      TxModel(
        id: "4",
        title: "Taxi",
        amount: 12,
        type: TxType.expense,
        categoryId: "transport",
        date: now.subtract(const Duration(days: 5)),
      ),
      TxModel(
        id: "5",
        title: "Shopping",
        amount: 65,
        type: TxType.expense,
        categoryId: "shopping",
        date: now.subtract(const Duration(days: 12)),
      ),
      TxModel(
        id: "6",
        title: "Football fee",
        amount: 20,
        type: TxType.expense,
        categoryId: "another", // ✅ fixed id
        date: now,
      ),
      TxModel(
        id: "7",
        title: "Salary",
        amount: 200,
        type: TxType.income,
        categoryId: "salary",
        date: now.subtract(const Duration(days: 2)),
      ),
      TxModel(
        id: "8",
        title: "Buy a car",
        amount: 200,
        type: TxType.expense,
        categoryId: "shopping",
        date: now.subtract(const Duration(days: 2)),
      ),
      TxModel(
        id: "9",
        title: "Sell a car",
        amount: 200,
        type: TxType.income,
        categoryId: "salary",
        date: now,
      ),
    ]);
  }
}




// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:money_planning_app/controllers/category_controller.dart';
// import 'package:money_planning_app/controllers/transaction_controller.dart';
// import 'package:money_planning_app/models/category_model.dart';
// import 'package:money_planning_app/models/transaction_model.dart';
// import 'package:money_planning_app/services/api_service.dart';

// class ReportController extends GetxController {
//   final apiService = ApiService();
//   final transactionController = TransactionController(); // for transactions
//   final categoryController = CategoryController(); // for categories

//   // View-required properties
//   final selectedIndex = 0.obs;
//   final monthlyStats = Rxn<Map<String, dynamic>>();
//   final spendingByCategory = <Map<String, dynamic>>[].obs;
//   final transactions = <TransactionModel>[].obs;
//   final categories = <CategoryModel>[].obs;
//   final selectedMonth = DateTime.now().obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadData();
//   }

//   Future<void> loadData() async {
//     await Future.wait([
//       loadMonthlyStats(),
//       loadSpendingByCategory(),
//       loadTransactions(),
//       loadCategories(),
//     ]);
//     // updateCharts();
//   }

//   Future<void> loadMonthlyStats() async {
//     isLoading.value = true;
//     try {
//       final response = await apiService.getMonthlyStats(selectedMonth.value);
//       if (response.success) {
//         monthlyStats.value = response.data;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadSpendingByCategory() async {
//     try {
//       final response = await apiService.getSpendingByCategory(selectedMonth.value);
//       if (response.success) {
//         spendingByCategory.value = response.data ?? [];
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     }
//   }

//   Future<void> loadTransactions() async {
//     final response = await apiService.getTransactionsByDateRange(
//       startDate: DateTime(selectedMonth.value.year, selectedMonth.value.month, 1),
//       endDate: DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0),
//       type: 'expense',
//     );
//     if (response.success) {
//       transactions.value = response.data ?? [];
//     }
//   }

//   Future<void> loadCategories() async {
//     final response = await apiService.getCategories(type: 'expense');
//     if (response.success) {
//       categories.value = response.data ?? [];
//     }
//   }

//   void setIndex(int index) {
//     selectedIndex.value = index;
//     // Load data for selected period (implement daily/weekly logic)
//     loadData();
//   }

//   void changeMonth(DateTime newMonth) {
//     selectedMonth.value = newMonth;
//     loadData();
//   }

//   // VIEW-REQUIRED GETTERS
//   double get incomeTotal => monthlyStats.value?['total_income']?.toDouble() ?? 0.0;
//   double get expenseTotal => monthlyStats.value?['total_expense']?.toDouble() ?? 0.0;

//   Map<String, double> get expenseByCategory {
//     final map = <String, double>{};
//     for (var tx in transactions) {
//       map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amount;
//     }
//     return map;
//   }

//   List<PieChartSectionData> get sections {
//     final total = expenseTotal;
//     return categories.take(5).map((cat) {
//       final amount = expenseByCategory[cat.id] ?? 0.0;
//       final percentage = total > 0 ? (amount / total) : 0.0;
//       return PieChartSectionData(
//         color: cat.color != null ? Color(int.parse(cat.color!.replaceAll('#', '0xFF'))) : Colors.blue,
//         value: percentage,
//         radius: 60,
//         title: '${(percentage * 100).toInt()}%',
//         titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
//       );
//     }).toList();
//   }

//   List<TransactionModel> get topExpenses {
//     return transactions
//         .where((tx) => tx.type == 'expense')
//         .toList()
//       ..sort((a, b) => b.amount.compareTo(a.amount));
//   }

//   CategoryModel categoryOf(String categoryId) {
//     return categories.firstWhere((c) => c.id == categoryId, 
//         orElse: () => CategoryModel(id: '', userId: '', name: 'Unknown', type: 'expense'));
//   }
// }
