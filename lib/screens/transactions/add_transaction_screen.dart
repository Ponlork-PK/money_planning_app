import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/add_transactions_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final controller = Get.put(AddTransactionsController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
      leading: IconButton(
          onPressed: () => Get.back(result: true),
          icon: const Icon(Icons.arrow_back)),
      title: Obx(() => Text(controller.isEdit.value
          ? 'updateTransaction'.tr
          : 'addTransactionTitle'.tr)));

  Widget _buildBody(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(color: BaseColors.primary),
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // input amount
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('amountLabel'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.amountCtrl,
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                              decoration: InputDecoration(
                                hintText: 'amountHint'.tr,
                                fillColor:
                                    Theme.of(context).colorScheme.onSurface,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                          ),
                          _buildDropDown(context)
                        ],
                      ),
                    ),
                  ],
                )),

                // Select income or expense
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'transactionType'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        LayoutBuilder(
                          builder: (context, c) {
                            final half = c.maxWidth / 2;

                            return Obx(() {
                              final sel =
                                  controller.selectedTransactionType.value;

                              Widget seg({
                                required String text,
                                required Color color,
                                required bool selected,
                              }) {
                                return Container(
                                  width: half,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        selected ? color : color.withAlpha(120),
                                  ),
                                  child: Text(
                                    text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: BaseColors.appBarTitle),
                                  ),
                                );
                              }

                              return ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(16), // ✅ outer radius
                                child: CupertinoSlidingSegmentedControl<int>(
                                  groupValue: sel,
                                  padding: EdgeInsets.zero,
                                  backgroundColor:
                                      Colors.transparent, // ✅ remove default bg
                                  thumbColor: Colors
                                      .transparent, // ✅ remove sliding thumb
                                  children: {
                                    0: seg(
                                      text: 'incomeLabel'.tr,
                                      color: Colors.green,
                                      selected: sel == 0,
                                    ),
                                    1: seg(
                                      text: 'expenseLabel'.tr,
                                      color: Colors.red,
                                      selected: sel == 1,
                                    ),
                                  },
                                  onValueChanged: (v) {
                                    if (v != null) controller.setIndex(v);
                                  },
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                /// Only for expense
                Obx(() {
                  if (!controller.isExpense) {
                    return SizedBox.shrink();
                  }
                  return _inputForExpense(context);
                }),

                // input date
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'inputDate'.tr,
                          style: Theme.of(
                            context,
                          )
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => controller.opendDatePicker(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Obx(() {
                              return Text(
                                controller.label,
                                style: Theme.of(context).textTheme.bodyMedium!,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // input purpose
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('purposeLabel'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: controller.purposeCtrl,
                          maxLines: 5,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.surface),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.onSurface,
                              hintText: 'purposeLabel'.tr),
                        ),
                      ],
                    ),
                  ),
                ),

                // save button
                Obx(() => SafeArea(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                                onPressed: controller.isSaving.value
                                    ? null
                                    : () async {
                              await controller.submit();
                            },
                            child: controller.isSaving.value
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : Text(controller.isEdit.value
                                        ? 'updateBtn'.tr
                                        : 'saveBtn'.tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      );

  /// Build dropdown for amount and currency
  Widget _buildDropDown(BuildContext context) {
    return Row(
      children: [
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: BaseColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.selectedCurrency.value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: BaseColors.white),
              ),
            )),

        const SizedBox(width: 8),

        // ✅ Dropdown
        Obx(() => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(20),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                value: controller.selectedCurrency.value,
                icon: const Icon(Icons.arrow_drop_down),
                selectedItemBuilder: (context) => controller.currencies
                    .map((e) => const SizedBox.shrink())
                    .toList(),
                items: controller.currencies
                    .map((c) => DropdownMenuItem<String>(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) controller.setCurrency(val);
                },
              ),
            )),
      ],
    );
  }

  Widget _inputForExpense(BuildContext context) {
    return // Expense-only fields (Item Name + Payment Method)
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'itemNameLabel'.tr,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller.itemNameCtrl,
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.onSurface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'itemNameHint'.tr,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'paymentMethodLabel'.tr,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller.paymentMethodCtrl,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.onSurface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'paymentMethodHint'.tr,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
