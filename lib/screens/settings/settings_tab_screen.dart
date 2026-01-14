import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/settings_controller/settings_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/base_constants.dart';

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
      title: const Text(BaseConstants.settingsTitle),
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
                    Text(BaseConstants.notification),
                    Obx(() => Switch(
                      value: controller.isNotificationEnabled.value,
                      onChanged: controller.toggleNotification,
                      activeColor: BaseColors.activeColor,
                    )),
                  ],
                ),
              ),
            ),
            Spacer(),
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
            const Text(BaseConstants.selectCurrency),
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

            // ✅ Dropdown
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
                              child: Text(c),
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
              BaseConstants.preference,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),

            // Dark Mode row
            Row(
              children: [
                Text(BaseConstants.darkMode),
                const Spacer(),
                Obx(() => Switch(
                      value: controller.isDarkMode.value,
                      onChanged: controller.toggleDarkMode,
                      activeColor: BaseColors.activeColor,
                    )),
              ],
            ),

            const SizedBox(height: 10),

            // Language row
            Row(
              children: [
                Text(BaseConstants.language),
                const Spacer(),
                Obx(() => Row(
                      children: [
                        _langOption(
                          label: "EN",
                          selected: controller.language.value == "EN",
                          onTap: () => controller.setLanguage("EN"),
                        ),
                        const SizedBox(width: 18),
                        _langOption(
                          label: "KH",
                          selected: controller.language.value == "KH",
                          onTap: () => controller.setLanguage("KH"),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _langOption({required String label, required bool selected, required VoidCallback onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black54, width: 1.5),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
