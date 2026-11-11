import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

/// A single label–value row used in detail cards (Loan Summary, Transaction Detail).
class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;

  /// Optional leading icon shown inside a circle avatar.
  final IconData? icon;

  const DetailRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  /// Named constructor variant with a leading icon (used in TransactionDetailScreen).
  const DetailRowWidget.withIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (hasIcon) ...[
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              child: Icon(icon, color: BaseColors.primary),
            ),
            const SizedBox(width: 10),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
