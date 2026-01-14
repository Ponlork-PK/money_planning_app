import 'package:get/get.dart';

class AddLoanController extends GetxController {
  // Observable variable for currency state
  var currency = 'USD'.obs;

  final selectedLoanType = 'bank'.obs;
  final loanType = ["All", "Bank", "Micro", "Personal"].obs;

  final radioSelected = 0.obs;

  void setCurrency(String value) {
    currency.value = value;
  }
}