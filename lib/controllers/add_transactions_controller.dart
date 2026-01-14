import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionsController extends GetxController{
  // Available currencies (add more if you want)
  final currencies = <String>["KHR", "USD"].obs;

  // Selected currency
  final selectedCurrency = "KHR".obs;
  final selectedTransactionType = 0.obs;
  final selectedDates = <DateTime?>[].obs;

  final segRadius = 20.0;

  final selected = CashFlowType.income.obs;

  void select(CashFlowType type) => selected.value = type;

  bool get isIncome => selected.value == CashFlowType.income;
  bool get isExpense => selectedTransactionType.value == 1;

  void setCurrency(String value) {
    selectedCurrency.value = value;
  }

  /// Set selected transaction type
  void setIndex(int v) => selectedTransactionType.value = v;

  DateTime? get selectedDate => selectedDates.isNotEmpty ? selectedDates.first : null;
  String get label => selectedDate == null ? "Select Date" : DateFormat("MMMM dd, yyyy").format(selectedDate!);

  Future<void> opendDatePicker() async {
    final tempDates = RxList<DateTime?>(List<DateTime?>.from(selectedDates));

    final result = await Get.dialog<List<DateTime?>?>(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => SizedBox(
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.single,
                        useAbbrLabelForMonthModePicker: true,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        daySplashColor: Colors.blue.shade100,
                        selectedDayHighlightColor: Colors.blue
                      ),
                      value: tempDates, // ✅ FIX
                      onValueChanged: (dates) => tempDates.value = dates,
                    ),
                  )),
              Row(
                spacing: 30,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Get.back(),
                      child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () => Get.back(result: tempDates), // ✅ FIX
                      child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (result != null) {
      selectedDates.value = result;
    }
  }
}

enum CashFlowType { income, expense }
