import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/component/building_sheet_frame.dart';
import 'package:kaist_map/component/search/widget.dart';
import 'package:kaist_map/component/building_filter.dart';
import 'package:kaist_map/navigation/kakao_map/map_context.dart';
import 'package:provider/provider.dart';

class KMapMap extends StatefulWidget {
  const KMapMap({super.key});

  @override
  State<KMapMap> createState() => _KMapMapState();
}

class _KMapMapState extends State<KMapMap> {
  @override
  Widget build(BuildContext context) {
    final mapContext = context.read<KakaoMapContext>();
    final buildingContext = context.read<BuildingContext>();
    final filterContext = context.watch<BuildingCategoryFilterContext>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapContext.cleanUpPath();
    });
    buildingContext.buildings.then((buildings) {
      final filteredBuildings = filterContext.applyFilters(buildings);
      mapContext.setMarkers(filteredBuildings
          .map((BuildingData buildingData) => buildingData.toMarker(onTap: () {
                Scaffold.of(context)
                    .showBottomSheet((context) => BuildingSheetFrame(
                          buildingData: buildingData,
                        ));
              }))
          .toList());
    });

    return const SafeArea(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              KMapSearch(),
              SizedBox(height: 4),
              BuildingCategoryFilter(),
            ],
          )),
    );
  }
}
