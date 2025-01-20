import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/component/building_filter.dart';
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
    final startLatLng = routingContext.startLatLng;
    final endLatLng = routingContext.endLatLng;
    final pathData = routingContext.pathData;

    mapContext.onTap = (_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    };

    Future.wait([startLatLng.future, endLatLng.future]).then((values) {
      final start = values[0];
      final end = values[1];

      if (startBuildingData != null && endBuildingData != null) {
        pathData.future.then((path) {
          if (start != null && end != null && start != end && path.isDefined) {
            mapContext.showPath(path.value, start, end);
          }
        });
      } else {
        mapContext.cleanUpPath();
        buildingContext.buildings.then((buildings) {
          mapContext.setMarkers({
            ...buildings
                .map((BuildingData buildingData) => buildingData
                    .toMarker(
                        pageName: "map",
                        onTap: () {
                          Scaffold.of(context)
                              .showBottomSheet((context) => BuildingSheetFrame(
                                    buildingData: buildingData,
                                  ));
                        })
                    .copyWith(
                      iconParam: BitmapDescriptor.defaultMarkerWithHue(
                          startBuildingData
                                      ?.map((data) => data.id)
                                      .getOrElse(-1) ==
                                  buildingData.id
                              ? BitmapDescriptor.hueGreen
                              : endBuildingData
                                          ?.map((data) => data.id)
                                          .getOrElse(-1) ==
                                      buildingData.id
                                  ? BitmapDescriptor.hueBlue
                                  : BitmapDescriptor.hueRed),
                    ))
                .toSet(),
            if (startBuildingData == const None<BuildingData>() &&
                start != null)
              Marker(
                  markerId: const MarkerId("start"),
                  position: start,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen)),
            if (endBuildingData == const None<BuildingData>() && end != null)
              Marker(
                  markerId: const MarkerId("end"),
                  position: end,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue)),
          });
        });
      }
    });

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
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
                            onPressed: () {
                              final tmpStartBuildingData = startBuildingData;
                              routingContext
                                  .setStartBuildingData(endBuildingData);
                              routingContext
                                  .setEndBuildingData(tmpStartBuildingData);
                            },
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
                                    routingContext
                                        .setEndBuildingData(buildingData);
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: routingContext.toggleBeam,
                  backgroundColor: routingContext.wantBeam
                      ? KMapColors.darkBlue
                      : KMapColors.white,
                  child: Icon(Icons.bike_scooter,
                      color: routingContext.wantBeam
                          ? KMapColors.white
                          : KMapColors.darkBlue),
                ),
                FloatingActionButton.small(
                  onPressed: routingContext.toggleFreeOfRain,
                  backgroundColor: routingContext.wantFreeOfRain
                      ? KMapColors.darkBlue
                      : KMapColors.white,
                  child: Icon(Icons.thunderstorm,
                      color: routingContext.wantFreeOfRain
                          ? KMapColors.white
                          : KMapColors.darkBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationSearch extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final filterContext = context.watch<BuildingCategoryFilterContext>();

    return SearchAnchor(
      builder: (context, controller) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          controller.text = "${controller.text}1";
          controller.text =
              controller.text.substring(0, controller.text.length - 1);
        });

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
        return suggestionsBuilder(context, controller, filterContext,
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
