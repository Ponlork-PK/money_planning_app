import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/search_transaction_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';

class SearchTransactionScreen extends StatelessWidget {
  SearchTransactionScreen({super.key});

  final controller = Get.put(SearchTransactionController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Obx(() => _buildBody()),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      titleSpacing: 4,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      title: TextFormField(
        controller: controller.searchCtrl,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          filled: true,
          fillColor: BaseColors.primary,
          hintText: "searchTs".tr,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: BaseColors.darkTextPrimary),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusColor: BaseColors.appBarTitle,
        ),
        cursorColor: BaseColors.background,
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error.value.isNotEmpty) {
      return Center(child: Text(controller.error.value));
    }

    // empty query state (results cleared)
    if (controller.searchCtrl.text.trim().isEmpty) {
      return Center(child: Text("typeToSearch".tr));
    }

    if (controller.results.isEmpty) {
      return Center(child: Text("noResult".tr));
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.results.length,
      itemBuilder: (context, index) {
        final tx = controller.results[index];

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
            onTap: () {
              if (tx.id == null) return;
              Get.toNamed(
                RoutesName.transactionDetail,
                arguments: tx.id!, // UUID string
              );
            },
            child: ItemListWidget(
              icons: tx.type == 'expense' ? Icons.payment : Icons.attach_money,
              itemName: name,
              price: price,
              color: tx.type == 'expense' ? BaseColors.expense : BaseColors.income,
            ),
          ),
        );
      },
    );
  }
}
