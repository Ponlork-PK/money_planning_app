import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class SettingsTabScreen extends StatelessWidget {
  SettingsTabScreen({super.key});

  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("setting".tr),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(color: BaseColors.primary),
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: BaseColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          spacing: 10,
          children: [
            _selectCurrency(context),
            _preference(context),
            
        
            // notification
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("notification".tr),
                    Obx(() => Switch(
                      value: controller.isNotificationEnabled.value,
                      onChanged: controller.toggleNotification,
                      activeThumbColor: BaseColors.activeColor,
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoggingOut.value
                      ? null
                      : () => _showLogoutDialog(context),
                  icon: controller.isLoggingOut.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    controller.isLoggingOut.value
                        ? 'loggingOut'.tr
                        : 'logout'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BaseColors.expense,
                    disabledBackgroundColor: BaseColors.expense.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                )),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _selectCurrency(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 4,
        ),
        child: Row(
          children: [
            Text("defaultCurrency".tr),
            const Spacer(),

            // ✅ Selected currency display (auto update)
            Obx(() => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: BaseColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    controller.selectedCurrency.value,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BaseColors.appBarTitle),
                  ),
                )),

            const SizedBox(width: 8),

            // ✅ Dropdown — uses canonical codes (USD / KHR) as values
            Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(20),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    value: controller.selectedCurrency.value,
                    icon: const Icon(Icons.arrow_drop_down),
                    selectedItemBuilder: (context) =>
                            controller.currencies.map((e) => const SizedBox.shrink()).toList(),
                    items: controller.currencies
                        .map((c) => DropdownMenuItem<String>(
                              value: c,
                              // Show localized label, but store canonical code
                              child: Text(c == 'USD' ? 'usd'.tr : 'khr'.tr),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.setCurrency(val);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _preference(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "preference".tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Dark Mode
            Row(
              children: [
                Text("darkMode".tr),
                const Spacer(),
                Obx(() => Switch(
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                  activeThumbColor: BaseColors.activeColor,
                )),
              ],
            ),

            const SizedBox(height: 10),

            // ✅ Fixed Language Dropdown
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "language".tr,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Obx(() {
                    final currentLang = controller.language.value;
                    final validValue = ['en', 'km'].contains(currentLang) ? currentLang : 'en';
                    
                    return DropdownButton<String>(
                      value: validValue,
                      isExpanded: true,
                      underline: SizedBox(),
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (value) => controller.setLanguage(value!),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'km', child: Text('ខ្មែរ')),
                      ],
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('logout'.tr),
        content: Text('logoutConfirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(color: BaseColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // close dialog
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BaseColors.expense,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'logout'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
