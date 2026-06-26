import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
import 'package:money_planning_app/controllers/transaction_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/currency_converter.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/app_page_layout.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';
import 'package:money_planning_app/widgets/summary_card_widget.dart';

class TransactionTabScreen extends StatelessWidget {
  TransactionTabScreen({super.key});

  final controller = Get.put(TransactionTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() => _buildBody(context)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
        title: Text(
          'transaction'.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: BaseColors.appBarTitle,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RoutesName.searchTransaction),
            icon: const Icon(Icons.search),
          )
        ],
      );

  Widget _buildBody(BuildContext context) {
    if (controller.error.value.isNotEmpty) {
      return Container(
        width: double.infinity,
        color: BaseColors.primary,
        child: Center(
          child: Text(
            controller.error.value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return AppPageLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Summary card — reactive to currency changes via Obx
          Obx(() {
            final sym = CurrencyConverter.symbol(
                SettingsController.to.selectedCurrency.value);
            return SummaryCardWidget(
              currencySymbol: sym,
              balance: controller.balance.value,
              income: controller.income.value,
              expense: controller.expense.value,
              balanceLabel: 'balance'.tr,
              incomeLabel: 'income'.tr,
              expenseLabel: 'expense'.tr,
            );
          }),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 14, bottom: 6),
            child: Text(
              'tsHistory'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          /// Transaction list
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshTransactions,
              child: controller.transactions.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text('noTransaction'.tr)),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: controller.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = controller.transactions[index];

                        final sign = tx.type == 'expense' ? '-' : '+';
                        final price =
                            '$sign${tx.currencyCode} ${tx.amount.toStringAsFixed(2)}';

                        final name =
                            (tx.itemName?.trim().isNotEmpty == true)
                                ? tx.itemName!.trim()
                                : (tx.note?.trim().isNotEmpty == true)
                                    ? tx.note!.trim()
                                    : (tx.type == 'expense'
                                        ? 'Expense'
                                        : 'Income');

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: GestureDetector(
                            onTap: () async {
                              if (tx.id == null) return;
                              final result = await Get.toNamed(
                                RoutesName.transactionDetail,
                                arguments: tx.id!,
                              );
                              if (result == true) {
                                controller.refreshTransactions();
                              }
                            },
                            child: ItemListWidget(
                              icons: tx.type == 'expense'
                                  ? Icons.shopping_cart_outlined
                                  : Icons.attach_money,
                              itemName: name,
                              price: price,
                              color: tx.type == 'expense'
                                  ? BaseColors.expense
                                  : BaseColors.income,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
