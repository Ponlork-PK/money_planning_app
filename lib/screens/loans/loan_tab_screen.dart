import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/loan_controller/loan_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/base_constants.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/loan_card_widget.dart';

class LoanTabScreen extends StatelessWidget {
  LoanTabScreen({super.key});

  final controller = Get.put(LoanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar, 
      body: _buildBody(context)
    );
  }

  get _buildAppbar => AppBar(
    title: Text(BaseConstants.loanTitle)
  );

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30),
      color: BaseColors.primary,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
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
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
              
                  Obx(()=> Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    color: Colors.transparent,
                    child: CupertinoSlidingSegmentedControl<int>(
                      groupValue: controller.selectedIndex.value,
                      thumbColor: BaseColors.primary,
                      children: {
                        0: _buildSegment(context, BaseConstants.loanTypeAll, 0),
                        1: _buildSegment(context, BaseConstants.loanTypeBank, 1),
                        2: _buildSegment(context, BaseConstants.loanTypeMicro, 2),
                        3: _buildSegment(context, BaseConstants.loanTypePersonal, 3)
                      },
                      onValueChanged: (value){
                        if(value != null) {
                          debugPrint("Index: $value");
                          controller.selectedIndex.value = value;
                        }
                      }
                    ),
                  )),
              
                  Obx((){
                    return Column(
                      spacing: 4,
                      children: List.generate(
                        controller.filterdLoan.length, 
                        (index){
                          final loan = controller.filterdLoan[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: LoanCardWidget(
                              loanName: loan.name ?? "",
                              amount: loan.originalAmount ?? 0, 
                              lenderType: loan.lenderType ?? "", 
                              paidPercent: loan.paidPercent ?? 0, 
                              nextRepayment: loan.nextRepaymentDate ?? DateTime.now(),
                            )
                          );
                        }
                      ),
                    );
                  })
                ],
              ),
            ),
            Obx((){
              return Positioned(
                right: 20,
                bottom: 16,
                child: AnimatedSlide(
                  offset: Offset(0, controller.isShowButtons.value ? 0 : 2),
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: BaseColors.primary
                    ),
                    onPressed: (){
                      Get.toNamed(RoutesName.addLoan);
                    }, 
                    icon: Icon(Icons.add, color: BaseColors.background,)
                  ),
                )
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(BuildContext context, String text, int index){
    final isSelected = controller.selectedIndex.value == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text, 
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: isSelected ? BaseColors.background : BaseColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
        )
      )
    );
  }
}





// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:money_planning_app/controllers/loan_controller/loan_controller.dart';
// import 'package:money_planning_app/utils/base_colors.dart';
// import 'package:money_planning_app/utils/base_constants.dart';
// import 'package:money_planning_app/widgets/loan_card_widget.dart';

// class LoanTabScreen extends StatelessWidget {
//   const LoanTabScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ✅ MVC: Direct instantiation
//     final controller = Get.find<LoanController>();

//     return Scaffold(
//       appBar: _buildAppbar,
//       body: _buildBody(context, controller),
//     );
//   }

//   AppBar get _buildAppbar => AppBar(
//     title: Text(BaseConstants.loanTitle),
//   );

//   Widget _buildBody(BuildContext context, LoanController controller) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.only(top: 30),
//       color: BaseColors.primary,
//       child: Container(
//         padding: const EdgeInsets.only(top: 10),
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: BaseColors.background,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30)
//           )
//         ),
//         child: Stack(
//           children: [
//             // ✅ List of loans
//             Obx(() => controller.isLoading.value
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                   // controller: controller.scrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     children: [
//                       // ✅ Filter tabs
//                       Container(
//                         width: double.infinity,
//                         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//                         child: CupertinoSlidingSegmentedControl<int>(
//                           groupValue: 2,
//                           thumbColor: BaseColors.primary,
//                           children: {
//                             0: _buildSegment(context, BaseConstants.loanTypeAll, 0, controller),
//                             1: _buildSegment(context, BaseConstants.loanTypeBank, 1, controller),
//                             2: _buildSegment(context, BaseConstants.loanTypeMicro, 2, controller),
//                             3: _buildSegment(context, BaseConstants.loanTypePersonal, 3, controller),
//                           },
//                           onValueChanged: (value) {
//                             if (value != null) {
//                               // controller.setIndex(value);
//                             }
//                           },
//                         ),
//                       ),
                      
//                       // ✅ Backend loan cards
//                       Obx(() {
//                         if (controller.loans.isEmpty) {
//                           return const Padding(
//                             padding: EdgeInsets.all(40),
//                             child: Text('No loans yet. Tap + to add one.'),
//                           );
//                         }
                        
//                         return Column(
//                           spacing: 4,
//                           children: List.generate(
//                             6,
//                             (index) {
//                               // final loan = controller.filterdLoan[index];
//                               return Container(
//                                 margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//                                 child: LoanCardWidget(
//                                   loanName: '', // ✅ Backend
//                                   amount: 0.0, // ✅ Backend
//                                   lenderType: '', // ✅ Backend
//                                   paidPercent: 0.3, // ✅ Backend
//                                   nextRepayment: DateTime.now(), // ✅ Backend
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//             ),
            
//             // ✅ FAB
//             Obx(() => Positioned(
//               right: 20,
//               bottom: 16,
//               child: AnimatedSlide(
//                 offset: Offset(0, 2),
//                 duration: const Duration(milliseconds: 200),
//                 child: FloatingActionButton(
//                   onPressed: (){},
//                   backgroundColor: BaseColors.primary,
//                   child: const Icon(Icons.add, color: BaseColors.background),
//                 ),
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSegment(BuildContext context, String text, int index, LoanController controller) {
//     final isSelected = 1 == index;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         text,
//         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//           color: isSelected ? BaseColors.background : BaseColors.textPrimary,
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }
