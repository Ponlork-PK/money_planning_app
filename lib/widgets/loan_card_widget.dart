import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/utils/routes_name.dart';

class LoanCardWidget extends StatelessWidget {
  final String loanName;
  final double amount;
  final String lenderType;
  final double paidPercent; // 0.0–1.0
  final DateTime nextRepayment;

  const LoanCardWidget({
    super.key,
    required this.loanName,
    required this.amount,
    required this.lenderType,
    required this.paidPercent,
    required this.nextRepayment,
  });

  @override
  Widget build(BuildContext context) {
    final percentText = '${(paidPercent * 100).toStringAsFixed(0)}% Paid';
    final nextPaymentDate = DateFormat('MMM dd, yyyy').format(nextRepayment);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: title + amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(loanName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '\$${amount.toStringAsFixed(2)}', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Lender', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(lenderType, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),

            // Progress line
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: paidPercent.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
              ),
            ),

            const SizedBox(height: 4),

            // Bottom row: next repayment + percent text + button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('next repayment', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(nextPaymentDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(percentText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(RoutesName.loanDetail);
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
