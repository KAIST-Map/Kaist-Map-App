import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/utils/option.dart';

class RoutingContext extends ChangeNotifier {
  Option<BuildingData>? _startBuildingData;
  Option<BuildingData>? _endBuildingData;

  Option<BuildingData>? get startBuildingData => _startBuildingData;
  Option<BuildingData>? get endBuildingData => _endBuildingData;

  void setStartBuildingData(Option<BuildingData>? data) {
    _startBuildingData = data;
    notifyListeners();
  }

  void setEndBuildingData(Option<BuildingData>? data) {
    _endBuildingData = data;
    notifyListeners();
  }
}

extension BuildingDataToLatLng on Option<BuildingData> {
  Future<LatLng> toLatLng() async {
    return map((buildingData) =>
      Future.value(LatLng(buildingData.latitude, buildingData.longitude))).getOrElse(
        () async {
          var position = await Geolocator.getCurrentPosition();
          return LatLng(position.latitude, position.longitude);
        }()
      );
  }
}