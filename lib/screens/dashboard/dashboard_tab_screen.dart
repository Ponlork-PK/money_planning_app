import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/dash_board_controller.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/currency_converter.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/app_page_layout.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';
import 'package:money_planning_app/widgets/summary_card_widget.dart';

class DashboardTabScreen extends StatelessWidget {
  DashboardTabScreen({super.key});

  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody(context),
    );
  }

  get _buildAppBar => AppBar(
        title: Text(
          'dashboard'.tr,
          style: const TextStyle(
            color: BaseColors.card,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildBody(BuildContext context) => AppPageLayout(
        child: Column(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Summary card — reactive to currency changes via Obx
            Obx(() {
              final sym = CurrencyConverter.symbol(
                  SettingsController.to.selectedCurrency.value);
              return SummaryCardWidget(
                currencySymbol: sym,
                balance: controller.summary.value.balance,
                income: controller.summary.value.income,
                expense: controller.summary.value.expense,
                balanceLabel: 'balance'.tr,
                incomeLabel: 'income'.tr,
                expenseLabel: 'expense'.tr,
              );
            }),

            /// Add Transaction button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result =
                            await Get.toNamed(RoutesName.addTransaction);
                        if (result == true) {
                          controller.refreshDashboard();
                        }
                      },
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: BaseColors.background,
                            child: Icon(Icons.add,
                                color: BaseColors.primary, size: 26),
                          ),
                          Text(
                            'addTransaction'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: BaseColors.card,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'recentActivity'.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            /// Recent transactions list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshDashboard(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(() {
                      if (controller.recent.isEmpty) {
                        return Center(
                          child: Text(
                            'noTransaction'.tr,
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        );
                      }
                      return Column(
                        spacing: 10,
                        children: controller.recent.map((tx) {
                          final sign = tx.type == 'expense' ? '-' : '+';
                          final price =
                              '$sign${tx.currencyCode} ${tx.amount.toStringAsFixed(2)}';

                          return GestureDetector(
                            onTap: () async {
                              final refresh = await Get.toNamed(
                                  RoutesName.transactionDetail,
                                  arguments: tx.id);
                              if (refresh) {
                                controller.refreshDashboard();
                              }
                            },
                            child: ItemListWidget(
                              icons: Icons.shopping_cart_outlined,
                              itemName: tx.itemName ?? 'Income',
                              price: price,
                              color: tx.type == 'expense'
                                  ? BaseColors.expense
                                  : BaseColors.income,
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
