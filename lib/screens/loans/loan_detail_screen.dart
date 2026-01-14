import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_planning_app/controllers/loan_controller/loan_detail_controller.dart';
import 'package:money_planning_app/models/loans_model.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/base_constants.dart';

class LoanDetailsScreen extends StatelessWidget {
  LoanDetailsScreen({super.key});

  final controller = Get.put(LoanDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)), 
        title: const Text(BaseConstants.loanDetailTitle)
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.loan.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final loan = controller.loan.value!;

        return Container(
          width: double.infinity,
          color: BaseColors.primary,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: BaseColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              )
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      _currentLoanCard(context: context, loan: loan),
                      _loanSummaryCard(context: context, loan: loan),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Payment Schedule', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Column(
                        children: List.generate(6, (index){
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: PaymentRow(
                              amount: "200.00", 
                              date: DateTime.now(), 
                              backgroundColor: Colors.green.shade100, 
                              icon: Icons.check
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
                _buttons(),
              ],
            ),
          ),
        );
      }),
    );
  }
  

  // current_loan_card
  Widget _currentLoanCard({required BuildContext context, required Loan loan}) {

    final percent = loan.paidPercent?.clamp(0.0, 1.0);
    final percentText = '${((percent ?? 0) * 100).toStringAsFixed(0)}% Paid';

    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      decoration: BoxDecoration(
        color: BaseColors.primary,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Current loan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    loan.name ?? "",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '${loan.currentBalance?.toStringAsFixed(2)}\$',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 5,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
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

  // loan_summary_card.dart
  Widget _loanSummaryCard({required BuildContext context, required Loan loan}) {
    String formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loan Summary', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _row('Lender', loan.name ?? ''),
            _row('Original Amount', '${loan.originalAmount}\$'),
            _row('Interest Rate', '${((loan.interestRate ?? 0) * 100).toStringAsFixed(1)}%'),
            _row('Loan Term', '${loan.termMonths} months'),
            _row('Start', formatDate(loan.startDate ?? DateTime.now())),
            _row('End', formatDate(loan.endDate ?? DateTime.now())),
          ],
        ),
      ),
    );
  }

  // buttons
  Widget _buttons() {
    return Positioned(
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
                  onPressed: controller.onSettleEarly,
                  child: const Text('Settle Loan Early'),
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
                  onPressed: controller.onEditLoan,
                  child: const Text('Edit Loan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Row for loan summary card
Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 13, color: Colors.black54)),
        Text(value,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

class PaymentRow extends StatelessWidget {
  final String amount;          // 200.00
  final DateTime date;          // July 30, 2025
  final Color backgroundColor;  // row color
  final IconData icon;

  const PaymentRow({
    super.key,
    required this.amount,
    required this.date,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM dd, yyyy').format(date);

    return Container(
      padding: const EdgeInsets.only(left: 5),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: BaseColors.income,
        borderRadius: BorderRadius.circular(14)
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(
              "Payment #1",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Text(
              '\$200',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Text(
              dateText,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              radius: 16,
              backgroundColor: BaseColors.income,
              child: Icon(icon, size: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:money_planning_app/controllers/loan_controller/loan_controller.dart';
// import 'package:money_planning_app/models/loan_payment_model.dart';
// import 'package:money_planning_app/models/loans_model.dart';
// import 'package:money_planning_app/utils/base_colors.dart';
// import 'package:money_planning_app/utils/base_constants.dart';

// class LoanDetailsScreen extends StatelessWidget {

//   LoanDetailsScreen({super.key});

//   final String loanId = Get.arguments; // Pass this when navigating

//   @override
//   Widget build(BuildContext context) {
//     // ✅ MVC: Direct instantiation (no Get.put)
//     final controller = Get.put(LoanController());

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)), 
//         title: const Text(BaseConstants.loanDetailTitle)
//       ),
//       body: Obx(() {
//         // Load data when screen opens
//         if (controller.selectedLoan.value == null) {
//           controller.loadLoanDetails(loanId);
//         }

//         if (controller.isLoading.value || controller.selectedLoan.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final loan = controller.selectedLoan.value!; // ✅ Backend data

//         return Container(
//           width: double.infinity,
//           color: BaseColors.primary,
//           child: Container(
//             margin: const EdgeInsets.only(top: 30),
//             padding: const EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//               color: BaseColors.background,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30)
//               )
//             ),
//             child: Stack(
//               children: [
//                 SingleChildScrollView(
//                   controller: ScrollController(),
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _currentLoanCard(context: context, loan: loan),
//                       _loanSummaryCard(context: context, loan: loan),
                      
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           'Payment Schedule (${loan.payments?.length ?? 0} payments)',
//                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ),
                      
//                       // ✅ REAL payments from backend
//                       ...?loan.payments?.map((payment) => PaymentRow(
//                         amount: payment.amount.toStringAsFixed(2),
//                         date: payment.dueDate,
//                         backgroundColor: _getPaymentColor(payment),
//                         icon: _getPaymentIcon(payment),
//                         status: payment.status,
//                       )),
                      
//                       const SizedBox(height: 100), // space for buttons
//                     ],
//                   ),
//                 ),
//                 _buttons(controller),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   // ✅ Backend data
//   Widget _currentLoanCard({required BuildContext context, required LoanModel loan}) {
//     final percent = loan.paidPercentage / 100.0; // ✅ Backend getter
//     final percentText = '${loan.paidPercentage}% Paid'; // ✅ Backend property

//     return Container(
//       padding: const EdgeInsets.only(top: 8),
//       margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
//       decoration: BoxDecoration(
//         color: BaseColors.primary,
//         borderRadius: BorderRadius.circular(16)
//       ),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             spacing: 8,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Current loan',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//                   Text(
//                     loan.loanType?['name'] ?? loan.lenderName, // ✅ Backend data
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Text(
//                 '${loan.remainingAmount.toStringAsFixed(2)}\$', // ✅ Backend data
//                 style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: LinearProgressIndicator(
//                   value: percent,
//                   minHeight: 5,
//                   backgroundColor: Colors.grey.shade300,
//                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//                 ),
//               ),
//               Text(
//                 percentText,
//                 style: const TextStyle(fontSize: 12, color: Colors.blue),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ✅ Backend data
//   Widget _loanSummaryCard({required BuildContext context, required LoanModel loan}) {
//     String formatDate(DateTime d) => DateFormat('MMM dd, yyyy').format(d);
    
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Loan Summary', 
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             _row('Lender', loan.lenderName),
//             _row('Original Amount', '${loan.originalAmount.toStringAsFixed(2)}\$'),
//             _row('Remaining', '${loan.remainingAmount.toStringAsFixed(2)}\$'),
//             _row('Interest Rate', '${loan.interestRate.toStringAsFixed(1)}%'),
//             _row('Loan Term', '${loan.loanTermMonths} months'),
//             _row('Start Date', formatDate(loan.startDate)),
//             _row('Status', loan.status.toUpperCase()),
//             if (loan.purpose != null) _row('Purpose', loan.purpose!),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buttons(LoanController controller) {
//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: 10,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onPressed: (){}, // ✅ Controller method
//                 child: const Text('Settle Loan Early'),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   side: const BorderSide(color: Colors.grey),
//                 ),
//                 onPressed: (){}, // ✅ Controller method
//                 child: const Text('Edit Loan'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _row(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
//           Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }

// // ✅ Updated PaymentRow to use backend data
// class PaymentRow extends StatelessWidget {
//   final String amount;
//   final DateTime date;
//   final Color backgroundColor;
//   final IconData icon;
//   final String status; // ✅ Backend status

//   const PaymentRow({
//     super.key,
//     required this.amount,
//     required this.date,
//     required this.backgroundColor,
//     required this.icon,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final dateText = DateFormat('MMM dd, yyyy').format(date);
//     final paymentNumber = date.day; // or get from backend payment.paymentNumber

//     return Container(
//       padding: const EdgeInsets.only(left: 5),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: BaseColors.income,
//         borderRadius: BorderRadius.circular(14)
//       ),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           children: [
//             Text(
//               "Payment #$paymentNumber",
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//             ),
//             const Spacer(),
//             Text(
//               '\$$amount',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   dateText,
//                   textAlign: TextAlign.right,
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//                 Text(
//                   status.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: status == 'paid' ? Colors.green : Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 8),
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: BaseColors.income,
//               child: Icon(icon, size: 20, color: Colors.white),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ✅ Helper methods
// Color _getPaymentColor(LoanPaymentModel payment) {
//   if (payment.isPaid) return Colors.green.shade100;
//   if (payment.isOverdue) return Colors.red.shade100;
//   return Colors.blue.shade100;
// }

// IconData _getPaymentIcon(LoanPaymentModel payment) {
//   if (payment.isPaid) return Icons.check;
//   if (payment.isOverdue) return Icons.warning;
//   return Icons.schedule;
// }
