import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class BaseBottomSheet {
  BaseBottomSheet._();

  static Future<void> show(
      {required BuildContext context,
      double? heightPercentage,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      List<Widget> children = const <Widget>[]}) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Get.bottomSheet(
        barrierColor: BaseColors.black.withValues(alpha: .1),
        isDismissible: false,
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        SizedBox(
          height:
              heightPercentage != null ? screenHeight * heightPercentage : null,
          child: SafeArea(
            top: false,
            child: Column(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                mainAxisSize: heightPercentage != null
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: children),
          ),
        ));
  }
}
