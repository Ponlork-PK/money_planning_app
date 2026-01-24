import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/transaction_detail_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';

class TransactionDetailScreen extends StatelessWidget {
  TransactionDetailScreen({super.key});

  final controller = Get.put(TransactionDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody(context)),
      floatingActionButton: FloatingActionButton(
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: BaseColors.primary,
        onPressed: () async {
          final tx = controller.transaction.value;
          if (tx == null) return;

          final result = await Get.toNamed(
            RoutesName.addTransaction,
            arguments: tx,
          );
          if (result == true) {
            controller.fetchTransaction();
          }

        },
        child: Icon(Icons.edit, color: BaseColors.appBarTitle),
      )
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(result: true),
        icon: const Icon(Icons.arrow_back)
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return Container(
        color: BaseColors.primary,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.error.value.isNotEmpty) {
      return Container(
        color: BaseColors.primary,
        child: Center(
          child: Text(
            controller.error.value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final tx = controller.transaction.value;
    if (tx == null) {
      return Container(
        color: BaseColors.primary,
        child: const Center(
          child: Text('Transaction not found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final isExpense = tx.type == 'expense';
    final sign = isExpense ? '-' : '+';
    final amountText = "$sign${tx.currencyCode} ${tx.amount.toStringAsFixed(2)}";

    final title = (tx.itemName?.trim().isNotEmpty == true)
        ? tx.itemName!.trim()
        : (tx.note?.trim().isNotEmpty == true)
            ? tx.note!.trim()
            : (isExpense ? 'Expense' : 'Income');

    return Container(
      color: BaseColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: BaseColors.appBarTitle,
            child: Icon(
              isExpense ? Icons.keyboard_double_arrow_down : Icons.keyboard_double_arrow_up,
              size: 70,
              color: BaseColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            amountText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tx.type.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: Column(
                children: List.generate(controller.labels.length, (index) {
                  return _detailRow(
                    icon: controller.icons[index],
                    label: controller.labels[index],
                    value: controller.values[index],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon),
          ),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
