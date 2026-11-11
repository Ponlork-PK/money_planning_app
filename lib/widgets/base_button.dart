import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class BaseButton extends StatelessWidget {
  const BaseButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.icon,
      this.backgroundColor = BaseColors.primary,
      this.textColor = BaseColors.white,
      this.radius = 24,
      this.padding,
      this.hasBorder = false});
  final void Function()? onPressed;
  final IconData? icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: padding ??
                EdgeInsets.symmetric(vertical: icon != null ? 10 : 12),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              side: hasBorder
                  ? BorderSide(width: 1, color: BaseColors.grey)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(radius),
            )),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 26,
                color: textColor,
              ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
