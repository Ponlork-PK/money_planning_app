import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/transaction_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';

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
          "transaction".tr,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: BaseColors.appBarTitle, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RoutesName.searchTransaction),
            icon: const Icon(Icons.search),
          )
        ],
      );

  Widget _buildBody(BuildContext context) {
    // if (controller.isLoading.value) {
    //   return Container(
    //     width: double.infinity,
    //     color: BaseColors.primary,
    //     child: const Center(child: CircularProgressIndicator()),
    //   );
    // }

    if (controller.error.value.isNotEmpty) {
      return Container(
        width: double.infinity,
        color: BaseColors.primary,
        child: Center(
          child: Text(controller.error.value, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: BaseColors.primary,
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: BaseColors.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Summary Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 26),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              decoration: BoxDecoration(
                color: BaseColors.background,
                boxShadow: [
                  BoxShadow(color: BaseColors.itemIconBg, blurRadius: 4, spreadRadius: 4),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(() {
                final cur = controller.currency.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "balance".tr,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: BaseColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$cur ${controller.balance.value.toStringAsFixed(2)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: BaseColors.textPrimary),
                    )
                  ],
                );
              }),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 14, bottom: 6),
              child: Text(
                "tsHistory".tr,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            /// List
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshTransactions,
                child: controller.transactions.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 120),
                          Center(child: Text("noTransaction".tr)),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: controller.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = controller.transactions[index];

                          final sign = tx.type == 'expense' ? '-' : '+';
                          final price = "$sign${tx.currencyCode} ${tx.amount.toStringAsFixed(2)}";

                          final name = (tx.itemName?.trim().isNotEmpty == true)
                              ? tx.itemName!.trim()
                              : (tx.note?.trim().isNotEmpty == true)
                                  ? tx.note!.trim()
                                  : (tx.type == 'expense' ? "Expense" : "Income");

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: GestureDetector(
                              onTap: () async{
                                if (tx.id == null) return;
                                final result = await Get.toNamed(
                                  RoutesName.transactionDetail,
                                  arguments: tx.id!, // ✅ UUID String
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
                                color: tx.type == 'expense' ? BaseColors.expense : BaseColors.income,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
