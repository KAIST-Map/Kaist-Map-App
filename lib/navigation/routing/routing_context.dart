import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/routes/b2b.dart';
import 'package:kaist_map/api/routes/b2p.dart';
import 'package:kaist_map/api/routes/data.dart';
import 'package:kaist_map/api/routes/p2b.dart';
import 'package:kaist_map/api/routes/p2p.dart';
import 'package:kaist_map/navigation/kakao_map/core.dart';
import 'package:kaist_map/utils/option.dart';

class RoutingContext extends ChangeNotifier {
  Option<BuildingData>? _startBuildingData;
  Option<BuildingData>? _endBuildingData;
  bool _wantBeam = false;
  bool _wantFreeOfRain = false;
  Completer<LatLng?> _startLatLng = Completer();
  Completer<LatLng?> _endLatLng = Completer();
  Completer<Option<PathData>> _pathData = Completer();

  Option<BuildingData>? get startBuildingData => _startBuildingData;
  Option<BuildingData>? get endBuildingData => _endBuildingData;
  bool get wantBeam => _wantBeam;
  bool get wantFreeOfRain => _wantFreeOfRain;
  Completer<LatLng?> get startLatLng => _startLatLng;
  Completer<LatLng?> get endLatLng => _endLatLng;
  Completer<Option<PathData>> get pathData => _pathData;

  RoutingContext() {
    _startLatLng.complete(null);
    _endLatLng.complete(null);
    _pathData.complete(const None());
  }

  void setStartBuildingData(Option<BuildingData>? data) {
    _startBuildingData = data;

    _startLatLng = Completer();
    final copy = _startLatLng;
    data?._toLatLng().then((latLng) {
          copy.complete(latLng);
          notifyListeners();
        }) ??
        _startLatLng.complete(null);

    _fetchPath();

    notifyListeners();
  }

  void setEndBuildingData(Option<BuildingData>? data) {
    _endBuildingData = data;

    _endLatLng = Completer();
    final copy = _endLatLng;
    data?._toLatLng().then((latLng) {
          copy.complete(latLng);
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
                wantBeam: _wantBeam,
                wantFreeOfRain: _wantFreeOfRain,
              ).fetch()
            : P2BLoader(
                startLatitude: startLatLng.latitude,
                startLongitude: startLatLng.longitude,
                endBuildingId: endBuildingData!.value.id,
                wantBeam: _wantBeam,
                wantFreeOfRain: _wantFreeOfRain,
              ).fetch())
        : (isEndPosition
            ? B2PLoader(
                startBuildingId: startBuildingData!.value.id,
                endLatitude: endLatLng.latitude,
                endLongitude: endLatLng.longitude,
                wantBeam: _wantBeam,
                wantFreeOfRain: _wantFreeOfRain,
              ).fetch()
            : B2BLoader(
                startBuildingId: startBuildingData!.value.id,
                endBuildingId: endBuildingData!.value.id,
                wantBeam: _wantBeam,
                wantFreeOfRain: _wantFreeOfRain,
              ).fetch());

    _pathData = Completer();
    final copy = _pathData;
    pathDataFuture.then((pathData) {
      copy.complete(Some(pathData));
      notifyListeners();
    });
  }

  void toggleBeam() {
    _wantBeam = !_wantBeam;
    _fetchPath();
    notifyListeners();
  }

  void toggleFreeOfRain() {
    _wantFreeOfRain = !_wantFreeOfRain;
    _fetchPath();
    notifyListeners();
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
