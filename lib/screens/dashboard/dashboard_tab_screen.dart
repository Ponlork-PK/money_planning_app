import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/dash_board_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';

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
        title: Text("dashboard".tr,
            style: TextStyle(
                color: BaseColors.card,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      );

  Widget _buildBody(BuildContext context) => Container(
        width: double.infinity,
        color: BaseColors.primary,
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: BaseColors.background,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Card
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 26),
                decoration: BoxDecoration(
                    color: BaseColors.background,
                    boxShadow: [
                      BoxShadow(
                          color: BaseColors.itemIconBg,
                          blurRadius: 4,
                          spreadRadius: 4)
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("balance".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: BaseColors.textPrimary,
                                      fontWeight: FontWeight.bold)),
                          Obx(() => Text(
                                "\$${controller.summary.value.balance.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: BaseColors.textPrimary),
                              )),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("income".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: BaseColors.income,
                                          fontWeight: FontWeight.bold)),
                              Obx(() => Text(
                                    "\$${controller.summary.value.income.toStringAsFixed(2)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: BaseColors.income),
                                  )),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                            width: 1, height: 60, color: BaseColors.divider),
                        const Spacer(),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("expense".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: BaseColors.expense,
                                          fontWeight: FontWeight.bold)),
                              Obx(() => Text(
                                    "\$${controller.summary.value.expense.toStringAsFixed(2)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: BaseColors.expense),
                                  )),
                            ],
                          ),
                        ),
                        const Spacer()
                      ],
                    )
                  ],
                ),
              ),

              /// Elevated Button
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
                              CircleAvatar(
                                  radius: 14,
                                  backgroundColor: BaseColors.background,
                                  child: Icon(Icons.add,
                                      color: BaseColors.primary, size: 26)),
                              Text("addTransaction".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: BaseColors.card,
                                          fontWeight: FontWeight.bold))
                            ],
                          )),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("recentActivity".tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.refreshDashboard(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Obx(() {
                        if (controller.recent.isEmpty) {
                          return Center(
                              child: Text("noTransaction".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: BaseColors.itemIconBg)));
                        }
                        return Column(
                          children: controller.recent.map((tx) {
                            final sign = tx.type == 'expense' ? '-' : '+';
                            final price =
                                "$sign${tx.currencyCode} ${tx.amount.toStringAsFixed(2)}";

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
                                icons: Icons
                                    .shopping_cart_outlined, // map icon later using category icon
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
              )
            ],
          ),
        ),
      );
}
