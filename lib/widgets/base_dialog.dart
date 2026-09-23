import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class BaseDialog {
  void showDialog({
    required BuildContext context,
    String? title,
    required String description,
    String? confirmTxt,
    String? cancelTxt,
    Color? backgroundColor,
    void Function()? onPressedConfirm,
    void Function()? onPressedCancel,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title ?? 'logout'.tr,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content:
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: onPressedCancel ?? () => Get.back(),
            child: Text(
              cancelTxt ?? 'cancel'.tr,
              style: const TextStyle(color: BaseColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: onPressedConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: BaseColors.expense,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              confirmTxt ?? 'logout'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
