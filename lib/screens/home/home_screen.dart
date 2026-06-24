import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/bottom_nav_controller.dart';
import 'package:money_planning_app/screens/loans/loan_tab_screen.dart';
import 'package:money_planning_app/screens/settings/settings_tab_screen.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/screens/dashboard/dashboard_tab_screen.dart';
import 'package:money_planning_app/screens/report/report_tab_screen.dart';
import 'package:money_planning_app/screens/transactions/transaction_tab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());

    final pages = [
      DashboardTabScreen(),
      TransactionTabScreen(),
      ReportTabScreen(),
      LoanTabScreen(),
      SettingsTabScreen(),
    ];

    return Obx(() {
      final index = controller.currentIndex.value;
      return Scaffold(
        backgroundColor: BaseColors.background,
        body: IndexedStack(
          index: index,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: BaseColors.primary,
          unselectedItemColor: BaseColors.textSecondary,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: 'navHome'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.swap_horiz_outlined),
              label: 'navTransaction'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.pie_chart_outline),
              label: 'navReport'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: 'navLoan'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: 'navSettings'.tr,
            ),
          ],
        ),
      );
    });
  }
}
