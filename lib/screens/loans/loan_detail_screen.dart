import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/controllers/loan_controller/loan_detail_controller.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/app_page_layout.dart';
import 'package:money_planning_app/widgets/detail_row_widget.dart';
import 'package:money_planning_app/widgets/payment_row_widget.dart';

class LoanDetailsScreen extends StatelessWidget {
  LoanDetailsScreen({super.key});

  final controller = Get.put(LoanDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('loanDetailTitle'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppPageLayout(
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final err = controller.error.value;
        if (err != null && err.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(err,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center),
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

        return AppPageLayout(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'paymentSchedule'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),

                    Obx(() {
                      final list = controller.payments;
                      if (list.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text('noPaymentSchedule'.tr),
                        );
                      }

                      return Column(
                        children: list.map((p) {
                          final isPaid = p.status == PaymentStatus.paid;
                          return Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: PaymentRowWidget(
                              payment: p,
                              currency: loan.currencyCode,
                              onTap: () => controller.togglePaymentPaid(p),
                              backgroundColor: isPaid
                                  ? Colors.green.shade100
                                  : Colors.grey.shade200,
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
        );
      }),
    );
  }

  Widget _currentLoanCard(
      {required BuildContext context, required Loan loan}) {
    final percent = loan.paidPercent?.clamp(0.0, 1.0);
    final percentText =
        '${((percent ?? 0) * 100).toStringAsFixed(0)}% Paid';

    final cur = loan.currencyCode.toUpperCase();
    final balanceText = (cur == 'KHR')
        ? '${loan.currentBalance?.toStringAsFixed(0)} $cur'
        : '${loan.currentBalance?.toStringAsFixed(2)} $cur';

    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      decoration: BoxDecoration(
        color: BaseColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Card(
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'currentLoan'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    loan.lenderType,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                balanceText,
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 5,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                percentText,
                style:
                    const TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loanSummaryCard(
      {required BuildContext context, required Loan loan}) {
    String formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);

    final cur = loan.currencyCode.toUpperCase();
    final origText = (cur == 'KHR')
        ? '${loan.originalAmount.toStringAsFixed(0)} $cur'
        : '${loan.originalAmount.toStringAsFixed(2)} $cur';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'loanSummary'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DetailRowWidget(label: 'lenderLabel'.tr, value: loan.name),
            DetailRowWidget(label: 'originalAmount'.tr, value: origText),
            DetailRowWidget(
                label: 'interestRate'.tr,
                value: '${loan.interestRate.toStringAsFixed(1)}%'),
            DetailRowWidget(
                label: 'loanTerm'.tr,
                value: loan.termMonths == null
                    ? '-'
                    : '${loan.termMonths} ${'months'.tr}'),
            DetailRowWidget(
                label: 'startLabel'.tr,
                value: formatDate(loan.startDate)),
            DetailRowWidget(
                label: 'endLabel'.tr,
                value: loan.endDate == null
                    ? '-'
                    : formatDate(loan.endDate!)),
            DetailRowWidget(
                label: 'nextRepayment'.tr,
                value: loan.nextRepaymentDate == null
                    ? '-'
                    : formatDate(loan.nextRepaymentDate!)),
            DetailRowWidget(
                label: 'purposeOfLoan'.tr,
                value: loan.purpose ?? '-'),
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
            offset: Offset(
                0, controller.isShowButtons.value ? 0 : 1.5),
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => controller.onSettleEarly(),
                      child: Text('settleLoan'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final refresh = await Get.toNamed(
                            RoutesName.addLoan,
                            arguments: controller.loan.value);
                        if (refresh) controller.loadLoanDetails();
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
