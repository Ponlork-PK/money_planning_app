import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/utils/helper.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';

class LoanCardWidget extends StatelessWidget {
  final String loanId; // ✅ uuid for details route

  final String loanName;
  final double amount;
  final String lenderType;
  final double paidPercent; // 0.0–1.0

  final DateTime? nextRepayment; // ✅ can be null
  final String currencyCode; // ✅ USD / KHR

  const LoanCardWidget({
    super.key,
    required this.loanId,
    required this.loanName,
    required this.amount,
    required this.lenderType,
    required this.paidPercent,
    required this.nextRepayment,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final percentText =
        '${(paidPercent.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%';

    final nextPaymentDate = DateHelper.formatDate(nextRepayment);

    final cur = currencyCode.toUpperCase().trim();
    final amountText =
        cur == 'KHR' ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.blueAccent, width: 2),
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
                Expanded(
                  child: Text(
                    loanName,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$amountText $cur",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: BaseColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('lender'.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: BaseColors.grey)),
            Text(lenderType,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

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
            const SizedBox(height: 8),

            // next repayment row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('repay'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: BaseColors.grey)),
                Text(nextPaymentDate,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 6),

            // percent + details button
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(percentText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(
                  width: 5,
                ),
                Text('paid'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500)),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    // ✅ pass loanId for LoanDetailsController
                    Get.toNamed(
                      RoutesName.loanDetail,
                      arguments: loanId,
                    );
                  },
                  child: Text(
                    'viewDetail'.tr,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600, color: BaseColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
