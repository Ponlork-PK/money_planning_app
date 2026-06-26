import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/utils/base_colors.dart';

/// A single payment schedule row for the Loan Detail screen.
///
/// Displays payment label, amount, due date and a status icon.
/// Tapping toggles the paid/unpaid status.
class PaymentRowWidget extends StatelessWidget {
  final LoanPayment payment;
  final String currency;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentRowWidget({
    super.key,
    required this.payment,
    required this.currency,
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM dd, yyyy').format(payment.date);

    final cur = currency.toUpperCase().trim();
    final amountText = cur == 'KHR'
        ? payment.amount.toStringAsFixed(0)
        : payment.amount.toStringAsFixed(2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: BaseColors.income,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(payment.label, style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Text('$amountText $cur', style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Text(dateText, textAlign: TextAlign.right, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 16,
                backgroundColor: BaseColors.income,
                child: Icon(icon, size: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
