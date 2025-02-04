import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/local/bookmarks.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/constant/map.dart';
import 'package:kaist_map/navigation/kakao_map/map_context.dart';
import 'package:kaist_map/navigation/layout.dart';
import 'package:kaist_map/navigation/photo/widget.dart';
import 'package:kaist_map/navigation/routing/routing_context.dart';
import 'package:kaist_map/utils/option.dart';
import 'package:provider/provider.dart';

class BuildingInfoSheet extends StatefulWidget {
  final BuildingData buildingData;

  const BuildingInfoSheet({
    super.key,
    required this.buildingData,
  });

  @override
  State<BuildingInfoSheet> createState() => _BuildingInfoSheetState();
}

class _BuildingInfoSheetState extends State<BuildingInfoSheet> {
  static const int imageSize = 100;
  late BuildingData buildingData = widget.buildingData;

  @override
  Widget build(BuildContext context) {
    final Future<bool> isBookmarked =
        BookmarkChecker(buildingData.id).fetch(mock: false);

    final navigationContext = context.read<NavigationContext>();
    final routingContext = context.read<RoutingContext>();
    final mapContext = context.read<KakaoMapContext>();

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
                      children: widget.buildingData.categories
                          .map((category) => category.getIcon())
                          .toList(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.buildingData.alias
                          .where((name) => name.trim().isNotEmpty)
                          .map((name) => "#${name.trim()}")
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return BuildingPhotoView(buildingData);
                      },
                      opaque: false));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: buildingData.name,
                    child: Image.network(
                      buildingData.imageUrls.elementAtOrNull(0) ??
                          "https://picsum.photos/$imageSize?image=9",
                      width: imageSize.toDouble(),
                      height: imageSize.toDouble(),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Container(
                                  width: imageSize.toDouble(),
                                  height: imageSize.toDouble(),
                                  color: KMapColors.darkGray.shade300,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: imageSize.toDouble(),
                        height: imageSize.toDouble(),
                        color: KMapColors.darkGray.shade300,
                        child: const Center(
                            child: Icon(
                          Icons.error,
                          color: KMapColors.darkGray,
                          size: 50,
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              ((bool enabled) {
                return FilledButton.icon(
                    onPressed: () {
                      if (enabled) {
                        routingContext.setStartBuildingData(const None());
                        routingContext.setEndBuildingData(Some(buildingData));
                        navigationContext.setSelectedIndex(2);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('카이스트 안에서만 사용 가능합니다.')),
                        );
                      }
                    },
                    style: enabled
                        ? null
                        : ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                KMapColors.darkGray.shade800),
                          ),
                    icon: const Icon(Icons.directions),
                    label: const Text("길찾기"));
              })(mapContext.myLocation?.inBound(
                      southWestBound: KaistLocation.kaistSouthWestBound,
                      northEastBound: KaistLocation.kaistNorthEastBound) ==
                  true),
              const SizedBox(width: 8),
              OutlinedButton(
                  onPressed: () {
                    routingContext.setStartBuildingData(Some(buildingData));
                    navigationContext.setSelectedIndex(2);
                  },
                  child: const Text("출발")),
              const SizedBox(width: 8),
              OutlinedButton(
                  onPressed: () {
                    routingContext.setEndBuildingData(Some(buildingData));
                    navigationContext.setSelectedIndex(2);
                  },
                  child: const Text("도착")),
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
                          if (success) {
                            setState(() {
                              if (navigationContext.selectedIndex == 1) {
                                navigationContext.refresh();
                              }
                            });
                          }
                        });
                      } else {
                        BookmarkAdder(buildingData.id)
                            .fetch(mock: false)
                            .then((success) {
                          if (success) {
                            setState(() {
                              if (navigationContext.selectedIndex == 1) {
                                navigationContext.refresh();
                              }
                            });
                          }
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
