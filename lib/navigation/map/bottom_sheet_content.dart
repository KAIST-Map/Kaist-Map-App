import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/local/bookmarks.dart';
import 'package:kaist_map/constant/colors.dart';

class BottomSheetContent extends StatefulWidget {
  final BuildingData buildingData;

  const BottomSheetContent({
    super.key,
    required this.buildingData,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  static const int imageSize = 100;
  late BuildingData buildingData = widget.buildingData;

  @override
  Widget build(BuildContext context) {
    final Future<bool> isBookmarked =
        BookmarkChecker(buildingData.id).fetch(mock: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.buildingData.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: widget.buildingData.categoryIds
                          .map((category) => category.icon)
                          .toList(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.buildingData.alias
                          .map((name) => "#$name")
                          .join("  "),
                      maxLines: null,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: KMapColors.darkBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  buildingData.imageUrl.elementAtOrNull(0) ??
                      "https://picsum.photos/$imageSize?image=9",
                  width: imageSize.toDouble(),
                  height: imageSize.toDouble(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions),
                  label: const Text("길찾기")),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text("출발")),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text("도착")),
              const SizedBox(width: 8),
              const Spacer(),
              FutureBuilder<bool>(
                future: isBookmarked,
                builder: (context, snapshot) {
                  final done = snapshot.connectionState == ConnectionState.done;
                  return IconButton.filled(
                    icon: Icon(done && snapshot.data!
                        ? Icons.bookmark
                        : Icons.bookmark_border),
                    onPressed: () {
                      if (!done) return;
                      if (snapshot.data!) {
                        BookmarkRemover(buildingData.id)
                            .fetch(mock: false)
                            .then((success) {
                          if (success) setState(() {});
                        });
                      } else {
                        BookmarkAdder(buildingData.id)
                            .fetch(mock: false)
                            .then((success) {
                          if (success) setState(() {});
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
