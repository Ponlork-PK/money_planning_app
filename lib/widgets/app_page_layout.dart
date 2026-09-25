import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

/// The standard full-screen page layout used across every tab screen.
class AppPageLayout extends StatelessWidget {
  /// Content rendered inside the white rounded area.
  final Widget child;

  /// Padding applied at the top of the blue strip before the white card.
  final double topPadding;

  /// Optional top padding inside the white card (default 10).
  final double innerTopPadding;

  const AppPageLayout({
    super.key,
    required this.child,
    this.topPadding = 30,
    this.innerTopPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: topPadding),
      color: BaseColors.primary,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: innerTopPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: child,
      ),
    );
  }
}
