import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/navigation/kakao_map/core.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapContext extends ChangeNotifier {
  WebViewController? _controller;
  WebViewController? get controller => _controller;
  set controller(WebViewController? controller) {
    _controller = controller;
    notifyListeners();
  }

  List<Marker> _markers = [];
  List<Marker> get markers => _markers;
  List<Polyline> _polylines = [];
  List<Polyline> get polylines => _polylines;

  LatLng? _myLocation;
  LatLng? get myLocation => _myLocation;
  Marker? get myLocationMarker => _myLocation != null ? Marker(
      name: "my-position",
      lat: _myLocation!.latitude,
      lng: _myLocation!.longitude,
      width: 20,
      height: 20,
      offsetY: 10,
      image: "https://kaist-map.github.io/Kaist-Map-App/my_location_pin.png",
      draggable: false,
      importance: 99,
      onTap: () {}) : null;

  void startMyLocationService() {
    Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high))
        .listen((position) {
      _myLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  void setMarkers(List<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  void cleanUpPath() {
    _markers = [];
    _polylines = [];
    notifyListeners();
  }

  void showPath(List<LatLng> path, LatLng start, LatLng end) {
    if (controller == null) {
      return;
    }

    _showTwoLocations(start, end);

    const mediumBlue = "#004187";
    final pathPolyline = Polyline(
      path: path,
      strokeWeight: 5,
      strokeColor: mediumBlue,
      strokeOpacity: 1,
      strokeStyle: "solid",
    );

    final startLine = Polyline(
      path: [start, path.first],
      strokeWeight: 5,
      strokeColor: mediumBlue,
      strokeOpacity: 1,
      strokeStyle: "dot",
    );

    final endLine = Polyline(
      path: [path.last, end],
      strokeWeight: 5,
      strokeColor: mediumBlue,
      strokeOpacity: 1,
      strokeStyle: "dot",
    );

    final startMarker = Marker(
      name: "start",
      lat: start.latitude,
      lng: start.longitude,
      image: "https://kaist-map.github.io/Kaist-Map-App/map_pin_green.png",
      draggable: false,
      importance: 128,
      onTap: () {},
    );

    final endMarker = Marker(
      name: "end",
      lat: end.latitude,
      lng: end.longitude,
      image: "https://kaist-map.github.io/Kaist-Map-App/map_pin.png",
      draggable: false,
      importance: 128,
      onTap: () {},
    );

    _markers = [startMarker, endMarker];
    _polylines = [pathPolyline, startLine, endLine];
    notifyListeners();
  }

  void _showTwoLocations(LatLng start, LatLng end) {
    Future.delayed(const Duration(milliseconds: 310), () {
      controller?.runJavaScript('''
        lookAtTwoPoints(
          ${start.latitude.toStringAsFixed(14)},
          ${start.longitude.toStringAsFixed(14)},
          ${end.latitude.toStringAsFixed(14)},
          ${end.longitude.toStringAsFixed(14)}
        );
      ''');
    });
  }

  void lookAtBuilding(BuildingData building) {
    if (controller == null) {
      return;
    }

    Future.delayed(const Duration(milliseconds: 310), () {
      controller?.runJavaScript('''
        lookCloserAt(
          ${building.latitude.toStringAsFixed(14)},
          ${building.longitude.toStringAsFixed(14)}
        );
      ''');
    });

    if (!markers.any((marker) => marker.name == "building-${building.id}"))
      return;

    final buildingMarker = markers
        .firstWhere((marker) => marker.name == "building-${building.id}");
    buildingMarker.onTap();
  }

  void lookAt(LatLng position) {
    if (controller == null) {
      return;
    }

    controller?.runJavaScript('''
      lookAt(
        ${position.latitude.toStringAsFixed(14)},
        ${position.longitude.toStringAsFixed(14)}
      );
    ''');
  }
}
