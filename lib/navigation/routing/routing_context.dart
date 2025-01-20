import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/routes/b2b.dart';
import 'package:kaist_map/api/routes/b2p.dart';
import 'package:kaist_map/api/routes/data.dart';
import 'package:kaist_map/api/routes/p2b.dart';
import 'package:kaist_map/api/routes/p2p.dart';
import 'package:kaist_map/utils/option.dart';

class RoutingContext extends ChangeNotifier {
  Option<BuildingData>? _startBuildingData;
  Option<BuildingData>? _endBuildingData;
  Completer<LatLng?> _startLatLng = Completer();
  Completer<LatLng?> _endLatLng = Completer();
  Completer<Option<PathData>> _pathData = Completer();

  Option<BuildingData>? get startBuildingData => _startBuildingData;
  Option<BuildingData>? get endBuildingData => _endBuildingData;
  Completer<LatLng?> get startLatLng => _startLatLng;
  Completer<LatLng?> get endLatLng => _endLatLng;
  Completer<Option<PathData>> get pathData => _pathData;

  void setStartBuildingData(Option<BuildingData>? data) {
    _startBuildingData = data;

    _startLatLng = Completer();
    data?._toLatLng().then((latLng) {
          _startLatLng.complete(latLng);
          notifyListeners();
        }) ??
        _startLatLng.complete(null);

    _fetchPath();

    notifyListeners();
  }

  void setEndBuildingData(Option<BuildingData>? data) {
    _endBuildingData = data;

    _endLatLng = Completer();
    data?._toLatLng().then((latLng) {
          _endLatLng.complete(latLng);
          notifyListeners();
        }) ??
        _endLatLng.complete(null);

    _fetchPath();

    notifyListeners();
  }

  void _fetchPath() async {
    _pathData = Completer();

    final startLatLng = await _startLatLng.future;
    final endLatLng = await _endLatLng.future;

    if (_startBuildingData == null ||
        _endBuildingData == null ||
        _startBuildingData?.map((data) => data.id) ==
            _endBuildingData?.map((data) => data.id) ||
        startLatLng == null ||
        endLatLng == null) {
      _pathData.complete(const None());
      return;
    }

    final isStartPosition = _startBuildingData!.isEmpty;
    final isEndPosition = _endBuildingData!.isEmpty;

    final pathDataFuture = isStartPosition
        ? (isEndPosition
            ? P2PLoader(
                startLatitude: startLatLng.latitude,
                startLongitude: startLatLng.longitude,
                endLatitude: endLatLng.latitude,
                endLongitude: endLatLng.longitude,
                wantBeam: false,
                wantFreeOfRain: false,
              ).fetch()
            : P2BLoader(
                    startLatitude: startLatLng.latitude,
                    startLongitude: startLatLng.longitude,
                    endBuildingId: endBuildingData!.value.id,
                    wantFreeOfRain: false,
                    wantBeam: false)
                .fetch())
        : (isEndPosition
            ? B2PLoader(
                    startBuildingId: startBuildingData!.value.id,
                    endLatitude: endLatLng.latitude,
                    endLongitude: endLatLng.longitude,
                    wantFreeOfRain: false,
                    wantBeam: false)
                .fetch()
            : B2BLoader(
                    startBuildingId: startBuildingData!.value.id,
                    endBuildingId: endBuildingData!.value.id,
                    wantFreeOfRain: false,
                    wantBeam: false)
                .fetch());

    pathDataFuture.then((pathData) {
      _pathData.complete(Some(pathData));
      notifyListeners();
    });
  }
}

extension BuildingDataToLatLng on Option<BuildingData> {
  Future<LatLng> _toLatLng() async {
    return map((buildingData) =>
            Future.value(LatLng(buildingData.latitude, buildingData.longitude)))
        .getOrElse(() async {
      var position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }());
  }
}
