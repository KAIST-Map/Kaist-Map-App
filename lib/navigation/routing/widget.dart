import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/component/building_sheet_frame.dart';
import 'package:kaist_map/component/search/widget.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:kaist_map/navigation/routing/routing_context.dart';
import 'package:kaist_map/utils/option.dart';
import 'package:provider/provider.dart';

class KMapRoutingPage extends StatefulWidget {
  const KMapRoutingPage({super.key});

  @override
  State<KMapRoutingPage> createState() => _KMapRoutingPageState();
}

class _KMapRoutingPageState extends State<KMapRoutingPage> {
  @override
  Widget build(BuildContext context) {
    final mapContext = context.read<MapContext>();
    final buildingContext = context.read<BuildingContext>();
    final routingContext = context.watch<RoutingContext>();
    final startBuildingData = routingContext.startBuildingData;
    final endBuildingData = routingContext.endBuildingData;

    mapContext.onTap = (_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    };

    buildingContext.buildings.then((buildings) {
      mapContext.setMarkers(buildings
          .map((BuildingData buildingData) => buildingData.toMarker(
              pageName: "map",
              onTap: () {
                Scaffold.of(context)
                    .showBottomSheet((context) => BuildingSheetFrame(
                          buildingData: buildingData,
                        ));
              }))
          .toSet());
    });

    if (startBuildingData != null && endBuildingData != null) {
      print("showing two locations");
      Future.wait([startBuildingData.toLatLng(), endBuildingData.toLatLng()])
          .then((values) {
        final start = values[0];
        final end = values[1];
        mapContext.showTwoLocations(start, end);
      });
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: KMapColors.darkBlue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.swap_vert,
                            color: KMapColors.white),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DestinationSearch(
                              selectedName: startBuildingData == null
                                  ? ""
                                  : startBuildingData
                                      .map((data) => data.name)
                                      .getOrElse("내 위치"),
                              hintText: "출발지를 입력하세요",
                              onBuildingDataChanged:
                                  (Option<BuildingData>? buildingData) {
                                routingContext
                                    .setStartBuildingData(buildingData);
                              },
                            ),
                            DestinationSearch(
                              selectedName: endBuildingData == null
                                  ? ""
                                  : endBuildingData
                                      .map((data) => data.name)
                                      .getOrElse("내 위치"),
                              hintText: "도착지를 입력하세요",
                              onBuildingDataChanged:
                                  (Option<BuildingData>? buildingData) {
                                routingContext.setEndBuildingData(buildingData);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DestinationSearch extends StatefulWidget {
  final String hintText;
  final String selectedName;
  final void Function(Option<BuildingData>?) onBuildingDataChanged;

  const DestinationSearch({
    super.key,
    required this.hintText,
    required this.selectedName,
    required this.onBuildingDataChanged,
  });

  @override
  State<DestinationSearch> createState() => _DestinationSearchState();
}

class _DestinationSearchState extends State<DestinationSearch> {
  String get hintText => widget.hintText;
  String get selectedName => widget.selectedName;
  void Function(Option<BuildingData>?) get onBuildingDataChanged =>
      widget.onBuildingDataChanged;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return Material(
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  splashColor: KMapColors.white.shade50,
                  onTap: () {
                    onBuildingDataChanged(null);
                    controller.clear();
                    controller.openView();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedName.isEmpty ? hintText : selectedName,
                          style: TextStyle(
                              color: selectedName.isEmpty
                                  ? KMapColors.white.shade300
                                  : KMapColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    onBuildingDataChanged(
                        selectedName.isEmpty ? const None() : null);
                    setState(() {});
                  },
                  icon: selectedName.isEmpty
                      ? const Icon(Icons.near_me,
                          color: KMapColors.white, size: 15)
                      : const Icon(Icons.close,
                          size: 15, color: KMapColors.white)),
            ],
          ),
        );
      },
      viewHintText: hintText,
      suggestionsBuilder: (context, controller) {
        return suggestionsBuilder(context, controller, () => setState(() {}),
            onResultTap: (buildingData) {
          onBuildingDataChanged(Some(buildingData));
        });
      },
      viewBuilder: (suggestions) {
        return SearchView(
          suggestions: suggestions,
        );
      },
    );
  }
}
