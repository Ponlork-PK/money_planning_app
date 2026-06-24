import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/controllers/loan_controller/loan_detail_controller.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';

class LoanDetailsScreen extends StatelessWidget {
  LoanDetailsScreen({super.key});

  final controller = Get.put(LoanDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        title: Text('loanDetailTitle'.tr)
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 30),
            color: BaseColors.primary,
            child: Container(
              decoration: BoxDecoration(
                color: BaseColors.background,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(30), right: Radius.circular(30))
              ),
              child: const Center(child: CircularProgressIndicator())));
        }

        final err = controller.error.value;
        if (err != null && err.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(err, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => controller.loadLoanDetails(),
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            ),
          );
        }

        final loan = controller.loan.value;
        if (loan == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 30),
          color: BaseColors.primary,
          child: RefreshIndicator(
            onRefresh: () => controller.loadLoanDetails(),
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: BaseColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _currentLoanCard(context: context, loan: loan),
                        _loanSummaryCard(context: context, loan: loan),
            
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'paymentSchedule'.tr,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
            
                        Obx(() {
                          final list = controller.payments;
                          if (list.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text('noPaymentSchedule'.tr),
                            );
                          }
            
                          return Column(
                            children: list.map((p) {
                              final isPaid = p.status == PaymentStatus.paid;
            
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: PaymentRow(
                                  payment: p,
                                  currency: loan.currencyCode,
                                  onTap: () => controller.togglePaymentPaid(p),
                                  backgroundColor: isPaid ? Colors.green.shade100 : Colors.grey.shade200,
                                  icon: isPaid ? Icons.check : Icons.schedule,
                                ),
                              );
                            }).toList(),
                          );
                        }),
            
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
            
                  _buttons(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _currentLoanCard({required BuildContext context, required Loan loan}) {
    final percent = loan.paidPercent?.clamp(0.0, 1.0);
    final percentText = '${((percent ?? 0) * 100).toStringAsFixed(0)}% Paid';

    final cur = loan.currencyCode.toUpperCase();
    final balanceText = (cur == 'KHR')
        ? "${loan.currentBalance?.toStringAsFixed(0)} $cur"
        : "${loan.currentBalance?.toStringAsFixed(2)} $cur";

    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      decoration: BoxDecoration(
        color: BaseColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('currentLoan'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    loan.lenderType,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                balanceText,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 5,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                percentText,
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loanSummaryCard({required BuildContext context, required Loan loan}) {
    String formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);

    final cur = loan.currencyCode.toUpperCase();
    final origText = (cur == 'KHR')
        ? "${loan.originalAmount.toStringAsFixed(0)} $cur"
        : "${loan.originalAmount.toStringAsFixed(2)} $cur";

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('loanSummary'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _row('lenderLabel'.tr, loan.name),
            _row('originalAmount'.tr, origText),
            _row('interestRate'.tr, '${loan.interestRate.toStringAsFixed(1)}%'),
            _row('loanTerm'.tr, loan.termMonths == null ? '-' : '${loan.termMonths} ${'months'.tr}'),
            _row('startLabel'.tr, formatDate(loan.startDate)),
            _row('endLabel'.tr, loan.endDate == null ? '-' : formatDate(loan.endDate!)),
            _row('nextRepayment'.tr, loan.nextRepaymentDate == null ? '-' : formatDate(loan.nextRepaymentDate!)),
            _row('purposeOfLoan'.tr, loan.purpose ?? '-')
          ],
        ),
      ),
    );
  }

  Widget _buttons() {
    return Obx(() => Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: AnimatedSlide(
            offset: Offset(0, controller.isShowButtons.value ? 0 : 1.5),
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => controller.onSettleEarly(),
                      child: Text('settleLoan'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: ()async{
                        final refresh = await Get.toNamed(RoutesName.addLoan, arguments: controller.loan.value);
                        if(refresh) controller.loadLoanDetails();
                      },
                      child: Text('editLoan'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

/// Row for loan summary card
Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

class PaymentRow extends StatelessWidget {
  final LoanPayment payment;
  final String currency;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentRow({
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
              Text("$amountText $cur", style: Theme.of(context).textTheme.bodySmall),
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
