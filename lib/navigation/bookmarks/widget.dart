import 'package:flutter/material.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/api/local/bookmarks.dart';
import 'package:kaist_map/component/building_filter.dart';
import 'package:kaist_map/component/building_info_sheet.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/kakao_map/map_context.dart';
import 'package:kaist_map/navigation/layout.dart';
import 'package:provider/provider.dart';

class KMapBookmarks extends StatelessWidget {
  const KMapBookmarks({super.key});

  @override
  Widget build(BuildContext context) {
    final mapContext = context.read<KakaoMapContext>();
    final buildingContext = context.watch<BuildingContext>();
    final Future<List<int>> bookmarks = BookmarksFetcher().fetch(mock: false);
    final filterContext = context.watch<BuildingCategoryFilterContext>();
    context.watch<NavigationContext>();
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapContext.cleanUpPath();
    });
    
    bookmarks.then((bookmarks) async {
      final buildings = await buildingContext.buildings;
      final filtered = filterContext.applyFilters(
          buildings.where((building) => bookmarks.contains(building.id)));
      mapContext.setMarkers(filtered
          .map((data) => buildings
              .firstWhere((building) => building.id == data.id)
              .toMarker(
                  onTap: () {
                    Scaffold.of(context).showBottomSheet((context) => Column(
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
                              buildingData: buildings.firstWhere(
                                  (building) => building.id == data.id),
                            ),
                          ],
                        ));
                  })).toList());
    });

    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: BuildingCategoryFilter(),
      ),
    );
  }
}
