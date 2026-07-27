import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/loan_controller/loan_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/app_page_layout.dart';
import 'package:money_planning_app/widgets/app_segmented_control.dart';
import 'package:money_planning_app/widgets/loan_card_widget.dart';

class LoanTabScreen extends StatelessWidget {
  LoanTabScreen({super.key});

  final controller = Get.put(LoanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("loan".tr)),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: BaseColors.primary,
        onPressed: () async {
          final result = await Get.toNamed(RoutesName.addLoan);
          if (result == true) {
            controller.loadLoans();
          }
        },
        child: const Icon(Icons.add, color: BaseColors.background, size: 36),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return AppPageLayout(
      child: RefreshIndicator(
        onRefresh: () => controller.loadLoans(),
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Segmented control
              Obx(() => AppSegmentedControl(
                    selectedIndex: controller.selectedIndex.value,
                    labels: [
                      'all'.tr,
                      'bank'.tr,
                      'micro'.tr,
                      'personal'.tr,
                    ],
                    onChanged: controller.setIndex,
                  )),
        
              // Content
              Obx(() {
        
                final err = controller.error.value;
                if (err != null && err.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          err,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => controller.loadLoans(),
                          child: Text('retry'.tr),
                        ),
                      ],
                    ),
                  );
                }
        
                final list = controller.filteredLoan;
        
                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Text('noLoans'.tr),
                  );
                }
        
                return Column(
                  children: List.generate(list.length, (index) {
                    final loan = list[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      child: LoanCardWidget(
                        loanId: loan.id!,
                        loanName: loan.name,
                        amount: loan.currentBalance ?? 0,
                        lenderType: loan.lenderType,
                        paidPercent: loan.paidPercent ?? 0,
                        nextRepayment: loan.nextRepaymentDate,
                        currencyCode: loan.currencyCode,
                      ),
                    );
                  }),
                );
              }),
        
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
