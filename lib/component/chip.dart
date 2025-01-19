import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/constant/colors.dart';

class KMapChip extends StatelessWidget {
  final bool isSelected;
  final void Function(bool) onChange;
  final BuildingCategory category;

  const KMapChip({
    super.key,
    required this.isSelected,
    required this.onChange,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onChange(!isSelected),
      style: ButtonStyle(
        backgroundColor: isSelected ? WidgetStateProperty.all(KMapColors.darkBlue) : null,
        elevation: WidgetStateProperty.all(2.5),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 2)),
      ),
      child: Row(
        children: [
          Text(category.name, style: TextStyle(color: isSelected ? KMapColors.white : KMapColors.darkBlue)),
          const SizedBox(width: 4),
          category.getIcon(color: isSelected ? KMapColors.white : KMapColors.darkBlue, size: 16),
        ],
      ),
    );
  }
}
