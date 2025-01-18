import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/constant/colors.dart';

class BottomSheetContent extends StatelessWidget {
  final BuildingData buildingData;
  static const int imageSize = 100;

  const BottomSheetContent({
    super.key,
    required this.buildingData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  height: imageSize.toDouble(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        buildingData.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: buildingData.category
                                    .map((category) => category.icon)
                                    .toList(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                buildingData.alias.map((name) => "#$name").join("  "),
                                maxLines: null,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: KMapColors.darkBlue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  buildingData.imageUrl ??
                      "https://picsum.photos/$imageSize?image=9",
                  width: imageSize.toDouble(),
                  height: imageSize.toDouble(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.directions),
                label: const Text("길찾기")),
              const SizedBox(width: 4),
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.start),
                label: const Text("길찾기")),
            ],
          ),
          const SizedBox(height: 4),
          const Center(child: Text("TODO")),
        ],
      ),
    );
  }
}
