import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/report_controller.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/currency_converter.dart';
import 'package:money_planning_app/widgets/app_page_layout.dart';
import 'package:money_planning_app/widgets/app_segmented_control.dart';
import 'package:money_planning_app/widgets/app_state_indicator.dart';

class ReportTabScreen extends StatelessWidget {
  ReportTabScreen({super.key});

  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("report".tr),
        actions: [
          Obx(() => IconButton(
            onPressed: controller.isExporting.value ? null : () => controller.exportPdf(),
            icon: controller.isExporting.value
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.file_open_outlined),
          ))
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return AppPageLayout(
      child: RefreshIndicator(
        onRefresh: () => controller.loadReport(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period switcher
              Obx(() => AppSegmentedControl(
                    selectedIndex: controller.selectedIndex.value,
                    labels: ['daily'.tr, 'weekly'.tr, 'monthly'.tr],
                    onChanged: controller.setIndex,
                  )),

              // Loading / error
              Obx(() => AppStateIndicator(
                    isLoading: controller.isLoading.value,
                    error: controller.error.value,
                  )),

              Obx(() => _buildIncomeExpenseChart(context)),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 6),
                child: Text(
                  'topTs'.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: BaseColors.textPrimary,
                      ),
                ),
              ),

              Obx(() => _buildTopTransactions()),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseChart(BuildContext context) {
    final double income = controller.incomeTotal;
    final double expense = controller.expenseTotal;
    final String sym = CurrencyConverter.symbol(SettingsController.to.selectedCurrency.value);

    const double maxBarHeight = 120.0;
    final double maxVal = math.max(income, expense).toDouble();

    final double incomeH =
        (maxVal == 0.0) ? 0.0 : (income / maxVal) * maxBarHeight;

    final double expenseH =
        (maxVal == 0.0) ? 0.0 : (expense / maxVal) * maxBarHeight;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "in_and_exp".tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: BaseColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _barWithLabel(
                  color: BaseColors.income,
                  label: "income".tr,
                  amount: "$sym${income.toStringAsFixed(2)}",
                  height: incomeH,
                ),
                _barWithLabel(
                  color: BaseColors.expense,
                  label: "expense".tr,
                  amount: "$sym${expense.toStringAsFixed(2)}",
                  height: expenseH,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _barWithLabel({
    required double height,
    required Color color,
    required String label,
    required String amount
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          width: 50,
          height: math.max(6, height),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        Container(width: 70, height: 2, color: Colors.grey),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
        Text(amount)
      ],
    );
  }

  // Widget _buildPieChart(BuildContext context) {
  //   return Obx(() {
  //     final expenseMap = controller.expenseByCategory; // Map<int,double>

  //     final legendCategories = controller.categories.where((c) {
  //       final cid = c.id;
  //       if (cid == null) return false;
  //       final v = expenseMap[cid] ?? 0.0;
  //       return v > 0.0;
  //     }).toList();

  //     return Card(
  //       elevation: 2,
  //       margin: const EdgeInsets.symmetric(horizontal: 16),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 12.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Spending by category",
  //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
  //                     fontWeight: FontWeight.bold,
  //                     color: BaseColors.textPrimary,
  //                   ),
  //             ),
  //             const SizedBox(height: 16),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                   height: 170,
  //                   width: 170,
  //                   child: PieChart(
  //                     PieChartData(
  //                       centerSpaceRadius: 32,
  //                       sections: controller.sections,
  //                       sectionsSpace: 1,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 if (legendCategories.isEmpty)
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 8.0),
  //                     child: Text(
  //                       "No expenses",
  //                       style: Theme.of(context)
  //                           .textTheme
  //                           .bodySmall
  //                           ?.copyWith(color: Colors.black54),
  //                     ),
  //                   )
  //                 else
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: legendCategories.map((c) {
  //                       final cid = c.id!;
  //                       final value = expenseMap[cid] ?? 0.0;

  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 4),
  //                         child: Row(
  //                           children: [
  //                             CircleAvatar(
  //                               backgroundColor: controller.colorOfCategory(cid),
  //                               radius: 7,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               "${c.name} (\$${value.toStringAsFixed(0)})",
  //                               style: const TextStyle(
  //                                 fontSize: 14,
  //                                 color: Colors.black87,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     }).toList(),
  //                   ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget _buildTopTransactions() {
    final list = controller.topTransactions;

    if (list.isEmpty) {
      return Center(child: Text("noTransaction".tr));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tx = list[index];

        final isIncome = tx.type.toLowerCase().trim() == 'income';
        final sign = isIncome ? "+" : "-";
        final color = isIncome ? BaseColors.income : Colors.red.shade400;

        final title = (tx.itemName?.trim().isNotEmpty == true)
            ? tx.itemName!.trim()
            : (tx.note?.trim().isNotEmpty == true)
                ? tx.note!.trim()
                : "Transaction";

        final catName = tx.categoryName ?? controller.categoryName(tx.categoryId);

        return ListTile(
          onTap: () => debugPrint("Tapped ${tx.id}"),
          leading: Text(
            "${index + 1}.",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(catName),
          trailing: Text(
            "$sign${tx.currencyCode.toUpperCase()} ${tx.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        );
      },
    );
  }
}
