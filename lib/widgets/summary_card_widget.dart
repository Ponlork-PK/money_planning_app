import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

/// Reusable summary card widget that shows Balance, Income, and Expense totals.
///
/// Used on both the Dashboard screen and the Transaction screen.
class SummaryCardWidget extends StatelessWidget {
  final String currencySymbol;
  final double balance;
  final double income;
  final double expense;

  /// Optional balance label (defaults to 'Balance').
  final String? balanceLabel;

  /// Optional income label (defaults to 'Income').
  final String? incomeLabel;

  /// Optional expense label (defaults to 'Expense').
  final String? expenseLabel;

  const SummaryCardWidget({
    super.key,
    required this.currencySymbol,
    required this.balance,
    required this.income,
    required this.expense,
    this.balanceLabel,
    this.incomeLabel,
    this.expenseLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 26),
      decoration: BoxDecoration(
        color: BaseColors.background,
        boxShadow: [
          BoxShadow(
            color: BaseColors.itemIconBg,
            blurRadius: 4,
            spreadRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  balanceLabel ?? 'Balance',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: BaseColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$currencySymbol${balance.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: BaseColors.textPrimary),
                ),
              ],
            ),
          ),

          // Income / Expense row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _amountColumn(
                context: context,
                label: incomeLabel ?? 'Income',
                amount: income,
                color: BaseColors.income,
              ),
              const Spacer(),
              Container(width: 1, height: 60, color: BaseColors.divider),
              const Spacer(),
              _amountColumn(
                context: context,
                label: expenseLabel ?? 'Expense',
                amount: expense,
                color: BaseColors.expense,
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountColumn({
    required BuildContext context,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          '$currencySymbol${amount.toStringAsFixed(2)}',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: color),
        ),
      ],
    );
  }
}
