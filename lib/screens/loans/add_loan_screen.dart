import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/loan_controller/add_loan_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class AddLoanScreen extends StatelessWidget {
  AddLoanScreen({super.key});

  final controller = Get.put(AddLoanController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                Get.back();
              }, 
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text('Add New Loan'),
          ),
        
          body: Column(
            children: [
              
              // 2. Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      // --- Card 1: Loaner Name ---
                      _lenderNameCard(context),
          
                      // --- Card 2: Loan Terms ---
                      _loanTermCard(context),
          
                      // --- Card 3: Purpose of Loan ---
                      _purposeCard(),
          
                      // Save Button
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: (){}, 
                                child: Text("Save")
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  /// This widget returns a card containing a text field for
  /// the user to input the purpose of the loan.
  Widget _purposeCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Purpose of Loan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                labelText: 'Enter purpose of loan',
              ),
            )
          ],
        ),
      ),
    );
  }

  /// This widget is responsible for displaying the loan terms card.
  /// It contains fields for the loan amount, start date, end date, interest rate,
  /// and currency selection.
  Widget _loanTermCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Terms',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            // Amounts
            _buildGreyInput('Amounts'),

            // Start / End Row
            Row(
              spacing: 10,
              children: [
                Expanded(child: _buildGreyInput('start')),
                Expanded(child: _buildGreyInput('end')),
              ],
            ),

            // Interest Rate
            _buildGreyInput('interest rate'),
        
            // Currency Radio Buttons (Reactive using Obx)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('currency', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 20),
        
                // USD Selection
                GestureDetector(
                  onTap: () => controller.setCurrency('USD'),
                  child: Obx(() => Row(
                    children: [
                      Icon(
                        controller.currency.value == 'USD'
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      const Text('USD'),
                    ],
                  )),
                ),
        
                const SizedBox(width: 20),
        
                // KHR Selection
                GestureDetector(
                  onTap: () => controller.setCurrency('KHR'),
                  child: Obx(() => Row(
                    children: [
                      Icon(
                        controller.currency.value == 'KHR'
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
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
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: BaseColors.primary,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loaner Name',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              // Dropdown (Mock)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: BaseColors.inputFieldBg,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Obx((){
                  return DropdownButton<String>(
                    value: controller.selectedLoanType.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(16),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'bank',
                        child: const Text('Bank'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'micro',
                        child: const Text('Micro'),
                      ),
                      DropdownMenuItem(
                        value: 'personal',
                        child: const Text('Personal')
                      )
                    ],
                    onChanged: (value) {
                      controller.selectedLoanType.value = value!;
                    },
                  );
                }),
              ),
              
              // Name Input + Done Button
              Row(
                spacing: 10,
                children: [
                  Expanded(child: _buildGreyInput("Lender Name")),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10   ),
                      backgroundColor: BaseColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: (){},
                    child: Text("Done", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: BaseColors.appBarTitle)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreyInput(String placeholder) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: placeholder,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}