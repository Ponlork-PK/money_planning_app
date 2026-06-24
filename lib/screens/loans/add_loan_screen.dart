import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/controllers/loan_controller/add_loan_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class AddLoanScreen extends StatelessWidget {
  AddLoanScreen({super.key});

  final controller = Get.put(AddLoanController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(result: true),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Obx(() => Text(controller.isEdit.value ? 'editLoanTitle'.tr : 'addLoanTitle'.tr)),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _lenderNameCard(context),
                      const SizedBox(height: 10),
                      _loanTermCard(context),
                      const SizedBox(height: 10),
                      _purposeCard(),
                      const SizedBox(height: 14),

                      Obx(() {
                        final err = controller.error.value;
                        if (err == null || err.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(err, style: const TextStyle(color: Colors.red)),
                        );
                      }),

                      const SizedBox(height: 10),

                      // Save Button
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                              onPressed: controller.isSaving.value ? null : controller.save,
                              child: controller.isSaving.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text('saveLoanBtn'.tr),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _purposeCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'purposeOfLoanLabel'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: BaseColors.textPrimary, fontSize: 20),
              controller: controller.purposeCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'enterPurposeHint'.tr,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loanTermCard(BuildContext context) {
    String fmt(DateTime d) => DateFormat('MMM dd, yyyy').format(d);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('loanTermsLabel'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextFormField(
              style: TextStyle(color: BaseColors.textPrimary, fontSize: 20),
              controller: controller.amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'amountsHint'.tr,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Obx(() => _dateBox(
                        label: 'startDateLabel'.tr,
                        text: controller.startDate.value == null ? 'selectDateHint'.tr : fmt(controller.startDate.value!),
                        onTap: () => controller.pickStartDate(context),
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() => _dateBox(
                        label: 'endDateLabel'.tr,
                        text: controller.endDate.value == null ? 'selectDateHint'.tr : fmt(controller.endDate.value!),
                        onTap: () => controller.pickEndDate(context),
                      )),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextFormField(
              style: TextStyle(color: BaseColors.textPrimary, fontSize: 20
              ),
              controller: controller.interestCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'interestRateHint'.tr,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              style: TextStyle(color: BaseColors.textPrimary, fontSize: 20),
              controller: controller.termCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'loanTermHint'.tr,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),

            const SizedBox(height: 10),

            // Currency
            Row(
              children: [
                Text('currencyLabel'.tr, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),

                GestureDetector(
                  onTap: () => controller.setCurrency('USD'),
                  child: Obx(() => Row(
                        children: [
                          Icon(
                            controller.currency.value == 'USD'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text('USD'),
                        ],
                      )),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => controller.setCurrency('KHR'),
                  child: Obx(() => Row(
                        children: [
                          Icon(
                            controller.currency.value == 'KHR'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text('KHR'),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lenderNameCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
      padding: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: BaseColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('loanerName'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: BaseColors.inputFieldBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Obx(() {
                  return DropdownButton<String>(
                    value: controller.selectedLoanType.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(16),
                    items: const [
                      DropdownMenuItem(value: 'bank', child: Text('Bank')),
                      DropdownMenuItem(value: 'micro', child: Text('Micro')),
                      DropdownMenuItem(value: 'family', child: Text('Family')),
                    ],
                    onChanged: (value) {
                      if (value != null) controller.selectedLoanType.value = value;
                    },
                  );
                }),
              ),

              const SizedBox(height: 10),

              TextFormField(
                style: TextStyle(color: BaseColors.textPrimary, fontSize: 20),
                controller: controller.lenderNameCtrl,
                  decoration: InputDecoration(
                    labelText: 'lenderNameHint'.tr,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateBox({
    required String label,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text),
      ),
    );
  }
}
