import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';

class BottomSheetContent extends StatelessWidget {
  final BuildingData buildingData;

  const BottomSheetContent({
    super.key,
    required this.buildingData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            buildingData.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            buildingData.category?.name ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            "ID: ${buildingData.id}",
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }
}
