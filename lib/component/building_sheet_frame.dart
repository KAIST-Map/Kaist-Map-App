import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/component/building_info_sheet.dart';
import 'package:kaist_map/constant/colors.dart';

class BuildingSheetFrame extends StatelessWidget {
  final BuildingData buildingData;

  const BuildingSheetFrame({
    super.key,
    required this.buildingData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: KMapColors.darkGray.shade400,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        BuildingInfoSheet(
          buildingData: buildingData,
        ),
      ],
    );
  }
}
