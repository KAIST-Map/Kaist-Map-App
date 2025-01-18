import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/component/search.dart';
import 'package:kaist_map/component/building_filter.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:kaist_map/navigation/map/bottom_sheet_content.dart';
import 'package:provider/provider.dart';

class KMapMap extends StatefulWidget {
  const KMapMap({super.key});

  @override
  State<KMapMap> createState() => _KMapMapState();
}

class _KMapMapState extends State<KMapMap> {
  @override
  Widget build(BuildContext context) {
    final mapContext = context.read<MapContext>();
    final buildingContext = context.read<ApiContext>();
    final filters = context.watch<BuildingCategoryFilterContext>().filters;

    mapContext.onTap = (_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    };

    buildingContext.buildings.then((buildings) {
      final filteredBuildings = buildings.where((building) {
        return filters.isEmpty || filters.contains(building.category);
      }).toList();
      mapContext.setMarkers(filteredBuildings
          .map((BuildingData e) => e.toMarker(onTap: () {
                Scaffold.of(context)
                    .showBottomSheet((context) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.3,
                        minChildSize: 0.15,
                        maxChildSize: 0.9,
                        builder: (context, scrollController) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Drag handle
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: BottomSheetContent(buildingData: e,),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }));
              }))
          .toSet());
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
