// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:money_planning_app/controllers/loan_controller/add_loan_controller.dart';
// import 'package:money_planning_app/utils/base_colors.dart';

// class AddLoanScreen extends StatelessWidget {
//   AddLoanScreen({super.key});

//   final controller = Get.put(AddLoanController());

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: ()=> FocusScope.of(context).unfocus(),
//       child: SafeArea(
//         top: false,
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: (){
//                 Get.back();
//               }, 
//               icon: const Icon(Icons.arrow_back),
//             ),
//             title: Text('Add New Loan'),
//           ),
        
//           body: Column(
//             children: [
              
//               // 2. Scrollable Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     spacing: 10,
//                     children: [
//                       // --- Card 1: Loaner Name ---
//                       _lenderNameCard(context),
          
//                       // --- Card 2: Loan Terms ---
//                       _loanTermCard(context),
          
//                       // --- Card 3: Purpose of Loan ---
//                       _purposeCard(),
          
//                       // Save Button
//                       Container(
//                         margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: (){}, 
//                                 child: Text("Save")
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }

//   /// This widget returns a card containing a text field for
//   /// the user to input the purpose of the loan.
//   Widget _purposeCard() {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           spacing: 10,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Purpose of Loan',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             TextFormField(
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintTextDirection: TextDirection.rtl,
//                 labelText: 'Enter purpose of loan',
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   /// This widget is responsible for displaying the loan terms card.
//   /// It contains fields for the loan amount, start date, end date, interest rate,
//   /// and currency selection.
//   Widget _loanTermCard(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
//         child: Column(
//           spacing: 10,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Loan Terms',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),

//             // Amounts
//             _buildGreyInput('Amounts'),

//             // Start / End Row
//             Row(
//               spacing: 10,
//               children: [
//                 Expanded(child: _buildGreyInput('start')),
//                 Expanded(child: _buildGreyInput('end')),
//               ],
//             ),

//             // Interest Rate
//             _buildGreyInput('interest rate'),
        
//             // Currency Radio Buttons (Reactive using Obx)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('currency', style: Theme.of(context).textTheme.bodyMedium),
//                 const SizedBox(width: 20),
        
//                 // USD Selection
//                 GestureDetector(
//                   onTap: () => controller.setCurrency('USD'),
//                   child: Obx(() => Row(
//                     children: [
//                       Icon(
//                         controller.currency.value == 'USD'
//                             ? Icons.radio_button_checked
//                             : Icons.radio_button_unchecked,
//                         size: 20,
//                         color: Colors.black,
//                       ),
//                       const SizedBox(width: 5),
//                       const Text('USD'),
//                     ],
//                   )),
//                 ),
        
//                 const SizedBox(width: 20),
        
//                 // KHR Selection
//                 GestureDetector(
//                   onTap: () => controller.setCurrency('KHR'),
//                   child: Obx(() => Row(
//                     children: [
//                       Icon(
//                         controller.currency.value == 'KHR'
//                             ? Icons.radio_button_checked
//                             : Icons.radio_button_unchecked,
//                         size: 20,
//                         color: Colors.black,
//                       ),
//                       const SizedBox(width: 5),
//                       const Text('KHR'),
//                     ],
//                   )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _lenderNameCard(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
//       padding: const EdgeInsets.only(top: 6),
//       decoration: BoxDecoration(
//         color: BaseColors.primary,
//         borderRadius: BorderRadius.circular(20)
//       ),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             spacing: 10,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Loaner Name',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//               ),

//               // Dropdown (Mock)
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: BaseColors.inputFieldBg,
//                   borderRadius: BorderRadius.circular(16)
//                 ),
//                 child: Obx((){
//                   return DropdownButton<String>(
//                     value: controller.selectedLoanType.value,
//                     isExpanded: true,
//                     underline: const SizedBox(),
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     borderRadius: BorderRadius.circular(16),
//                     items: [
//                       DropdownMenuItem<String>(
//                         value: 'bank',
//                         child: const Text('Bank'),
//                       ),
//                       DropdownMenuItem<String>(
//                         value: 'micro',
//                         child: const Text('Micro'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'personal',
//                         child: const Text('Personal')
//                       )
//                     ],
//                     onChanged: (value) {
//                       controller.selectedLoanType.value = value!;
//                     },
//                   );
//                 }),
//               ),
              
//               // Name Input + Done Button
//               Row(
//                 spacing: 10,
//                 children: [
//                   Expanded(child: _buildGreyInput("Lender Name")),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10   ),
//                       backgroundColor: BaseColors.primary,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
//                     ),
//                     onPressed: (){},
//                     child: Text("Done", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: BaseColors.appBarTitle)),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGreyInput(String placeholder) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: placeholder,
//         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//     );
//   }
// }



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
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Obx(() => Text(controller.isEdit.value ? "Edit Loan" : "Add New Loan")),
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
                                  : const Text("Save"),
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
            const Text(
              'Purpose of Loan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller.purposeCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter purpose of loan',
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
            Text('Loan Terms',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            TextFormField(
              controller: controller.amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amounts'),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Obx(() => _dateBox(
                        label: "Start",
                        text: controller.startDate.value == null ? "Select" : fmt(controller.startDate.value!),
                        onTap: () => controller.pickStartDate(context),
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() => _dateBox(
                        label: "End",
                        text: controller.endDate.value == null ? "Select" : fmt(controller.endDate.value!),
                        onTap: () => controller.pickEndDate(context),
                      )),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: controller.interestCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Interest rate (%)'),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: controller.termCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Loan term (months)'),
            ),

            const SizedBox(height: 10),

            // Currency
            Row(
              children: [
                Text('Currency', style: Theme.of(context).textTheme.bodyMedium),
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
              Text('Loaner Name',
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
                controller: controller.lenderNameCtrl,
                decoration: const InputDecoration(labelText: "Lender Name"),
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
