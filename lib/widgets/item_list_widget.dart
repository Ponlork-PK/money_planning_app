import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

class ItemListWidget extends StatelessWidget {
  final IconData icons;
  final String itemName;
  final String price;
  final Color color;
  const ItemListWidget({
    super.key,
    required this.icons,
    required this.itemName,
    required this.price,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: BaseColors.itemIconBg,
            child: Icon(icons, size: 32, color: BaseColors.iconColor)
          ),
          Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: BaseColors.textPrimary, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(price, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
