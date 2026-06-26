import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

/// A reusable `CupertinoSlidingSegmentedControl` styled to match the app design.
///
/// Used in the Report screen (Daily / Weekly / Monthly) and the Loan screen
/// (All / Bank / Micro / Personal).
class AppSegmentedControl extends StatelessWidget {
  /// The observable or plain index of the currently selected segment.
  final int selectedIndex;

  /// Labels to display for each segment tab.
  final List<String> labels;

  /// Called with the new index when a tab is tapped.
  final ValueChanged<int> onChanged;

  const AppSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> children = {
      for (int i = 0; i < labels.length; i++)
        i: _segment(context, labels[i], i),
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      color: Colors.transparent,
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: selectedIndex,
        thumbColor: BaseColors.primary,
        children: children,
        onValueChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }

  Widget _segment(BuildContext context, String text, int index) {
    final isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected ? BaseColors.background : BaseColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
      ),
    );
  }
}
