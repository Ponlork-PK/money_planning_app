// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:money_planning_app/utils/routes_name.dart';
//
// class TransactionTabScreen extends StatelessWidget {
//   const TransactionTabScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Static Data
//     final List<Map<String, dynamic>> transactions = [
//       {
//         'title': 'Shopping',
//         'subtitle': ' - shoes',
//         'amount': -100.00,
//         'icon': Icons.shopping_cart_outlined,
//       },
//       {
//         'title': 'Food',
//         'subtitle': null,
//         'amount': -100.00,
//         'icon': Icons.ramen_dining,
//       },
//       {
//         'title': 'School Pay',
//         'subtitle': null,
//         'amount': -100.00,
//         'icon': Icons.account_balance_wallet_outlined,
//       },
//       {
//         'title': 'Food',
//         'subtitle': null,
//         'amount': -100.00,
//         'icon': Icons.ramen_dining,
//       },
//     ];
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // 1. Blue Header Background
//           Container(
//             height: 200,
//             decoration: const BoxDecoration(
//               color: Color(0xFF0091EA), // Bright blue
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//           ),
//
//           // 2. Main Content
//           SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header (Title + Search Icon)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       const Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           'Transactions',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: IconButton(
//                           icon: const Icon(Icons.search, color: Colors.white, size: 28),
//                           onPressed: () {
//                             Get.toNamed(RoutesName.searchTransaction);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Total Balance Card
//                 Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFD9D9D9), // Light grey
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Total Balance',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         '\$500.00',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 25),
//
//                 // "Transactions Histories" Title
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Text(
//                     'Transactions Histories',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // "Today" Subtitle
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Text(
//                     'Today',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Transaction List
//                 Expanded(
//                   child: ListView.separated(
//                     padding: const EdgeInsets.only(top: 0, bottom: 20),
//                     itemCount: transactions.length,
//                     separatorBuilder: (context, index) => const Divider(
//                       color: Colors.black54,
//                       thickness: 1,
//                       indent: 70,     // Matches image indentation
//                       endIndent: 20,
//                       height: 1,
//                     ),
//                     itemBuilder: (context, index) {
//                       final item = transactions[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         child: Row(
//                           children: [
//                             // Icon
//                             CircleAvatar(
//                               radius: 24,
//                               backgroundColor: const Color(0xFFD9D9D9), // Light grey circle
//                               child: Icon(
//                                 item['icon'] as IconData,
//                                 color: Colors.black87,
//                                 size: 26,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//
//                             // Title with optional light grey subtitle (e.g., "- shoes")
//                             Expanded(
//                               child: RichText(
//                                 text: TextSpan(
//                                   text: item['title'],
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.black87,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   children: [
//                                     if (item['subtitle'] != null)
//                                       TextSpan(
//                                         text: item['subtitle'],
//                                         style: const TextStyle(
//                                           color: Colors.grey, // Grey for "- shoes"
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             // Amount
//                             Text(
//                               '-\$${(item['amount'] as double).abs().toStringAsFixed(2)}',
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/base_constants.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/item_list_widget.dart';

class TransactionTabScreen extends StatelessWidget {
  const TransactionTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    title: Text(
      BaseConstants.transactionTitle,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: BaseColors.appBarTitle, fontWeight: FontWeight.bold)
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
          onPressed: (){
            Get.toNamed(RoutesName.searchTransaction);
          },
          icon: Icon(Icons.search),
        ),
      )
    ],
  );

  Widget _buildBody(BuildContext context){
    return Container(
      width: double.infinity,
      color: BaseColors.primary,
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: BaseColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30)
          )
        ),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Amount Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 26),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              decoration: BoxDecoration(
                  color: BaseColors.background,
                  boxShadow: [
                    BoxShadow(color: BaseColors.itemIconBg, blurRadius: 4, spreadRadius: 4)
                  ],
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(BaseConstants.balanceDashboard, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: BaseColors.textPrimary, fontWeight: FontWeight.bold)),
                  Text(BaseConstants.amountDashboard, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BaseColors.textPrimary))
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(BaseConstants.tsHistory, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 4,
                  children: List.generate(15, (index){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ItemListWidget(icons: Icons.fastfood, itemName: "Food", price: "\$50"));
                  })
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
