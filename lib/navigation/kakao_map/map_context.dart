import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/routes/data.dart';
import 'package:kaist_map/navigation/kakao_map/core.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IsolateMarker {
  final String name;
  final double lat;
  final double lng;
  final int importance;
  final double width;
  final double height;
  final double offsetY;
  final String image;
  final bool draggable;

  IsolateMarker({
    required this.name,
    required this.lat,
    required this.lng,
    required this.importance,
    required this.width,
    required this.height,
    required this.offsetY,
    required this.image,
    required this.draggable,
  });

  double distanceToMeters(IsolateMarker other) {
    const double earthRadius = 6371000; // Earth's radius in meters
    final double lat1 = lat * (pi / 180); // Convert to radians
    final double lat2 = other.lat * (pi / 180);
    final double dLat = (other.lat - lat) * (pi / 180);
    final double dLng = (other.lng - lng) * (pi / 180);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
}

class ComputeMessage {
  final List<IsolateMarker> markers;
  final int zoomLevel;

  ComputeMessage(this.markers, this.zoomLevel);

  ComputeMessage.fromMarkersZoom(List<Marker> markers, this.zoomLevel)
      : markers = markers
            .map((marker) => IsolateMarker(
                  name: marker.name,
                  lat: marker.lat,
                  lng: marker.lng,
                  importance: marker.importance,
                  width: marker.width,
                  height: marker.height,
                  offsetY: marker.offsetY,
                  image: marker.image,
                  draggable: marker.draggable,
                ))
            .toList();
}

class KakaoMapContext extends ChangeNotifier {
  WebViewController? _controller;
  WebViewController? get controller => _controller;
  set controller(WebViewController? controller) {
    _controller = controller;
    notifyListeners();
  }

  LatLng? southWestBound;
  LatLng? northEastBound;

  List<Marker> _markers = [];
  List<Marker> get markers => _markers;
  List<List<Marker>> _showingMarkers = [[], [], [], [], [], []];
  List<List<Marker>> get showingMarkers => _showingMarkers;
  List<Polyline> _polylines = [];
  List<Polyline> get polylines => _polylines;
  int _zoomLevel = 4;
  int get zoomLevel => _zoomLevel;
  PathETA? _pathETA;
  PathETA? get pathETA => _pathETA;

  LatLng? _myLocation;
  LatLng? get myLocation => _myLocation;
  double? _direction;
  int? _lastMarkerDirection;
  Marker? get myLocationMarker => _myLocation != null
      ? Marker(
          name: "my-position",
          lat: _myLocation!.latitude,
          lng: _myLocation!.longitude,
          width: 30,
          height: 30,
          offsetY: 15,
          image: _direction != null
              ? "https://kaist-map.github.io/Kaist-Map-App/my_location_direction_pin/rotated_$_lastMarkerDirection.png"
              : "https://kaist-map.github.io/Kaist-Map-App/my_location_pin.png",
          draggable: false,
          importance: 99,
          onTap: () {})
      : null;

  int _getMarkerDirection() {
    if (_direction == null) {
      return 0;
    }

    int fiveDegreeDirection = (_direction! / 5).round() * 5;
    int positiveDirection = (fiveDegreeDirection + 720) % 360;
    int adjustedDirection = (360 - positiveDirection) % 360;

    return adjustedDirection;
  }

  void startMyLocationService() {
    Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high))
        .listen((position) {
      _myLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });

    FlutterCompass.events?.listen((event) {
      _direction = event.heading;

      if (_lastMarkerDirection == null ||
          _lastMarkerDirection != _getMarkerDirection()) {
        _lastMarkerDirection = _getMarkerDirection();
        notifyListeners();
      }
    });
  }

  void setMarkers(List<Marker> markers) {
    _markers = markers;
    _computeShowingMarkers();
    notifyListeners();
  }

  void setZoomLevel(int zoomLevel) {
    _zoomLevel = zoomLevel;
    notifyListeners();
  }

  Future<void> _computeShowingMarkers() async {
    const omitMarkersDistanceInMeters = [0, 10, 30, 60, 100, 200];

    Future<List<Marker>> singleZoomLevelShowingMarkers(int zoomLevel) async {
      final isolateMarkers = await compute((message) {
        message.markers.sort((a, b) {
          if (b.importance == a.importance) {
            return a.name.compareTo(b.name);
          }
          return b.importance.compareTo(a.importance);
        });
        final List<IsolateMarker> showingMarkers = [];

        for (var i = 0; i < message.markers.length; i++) {
          () {
            for (var j = 0; j < showingMarkers.length; j++) {
              if (message.markers[i].distanceToMeters(showingMarkers[j]) <
                  (omitMarkersDistanceInMeters
                          .elementAtOrNull(message.zoomLevel) ??
                      0)) {
                return;
              }
            }
            showingMarkers.add(message.markers[i]);
          }();
        }

        return showingMarkers;
      }, ComputeMessage.fromMarkersZoom([...markers], zoomLevel));

      return isolateMarkers
          .map((marker) => Marker(
                name: marker.name,
                lat: marker.lat,
                lng: marker.lng,
                importance: marker.importance,
                width: marker.width,
                height: marker.height,
                offsetY: marker.offsetY,
                image: marker.image,
                draggable: marker.draggable,
                onTap: markers.firstWhere((m) => m.name == marker.name).onTap,
              ))
          .toList();
    }

    _showingMarkers = await Future.wait(
        List.generate(6, (index) => singleZoomLevelShowingMarkers(index)));

    notifyListeners();
  }

  void cleanUpPath() {
    _markers = [];
    _polylines = [];
    notifyListeners();
  }

  void showPath(PathData pathData, LatLng start, LatLng end,
      {required bool wantBeam, required bool wantFreeOfRain}) {
    if (controller == null) {
      return;
    }

    _showTwoLocations(start, end);

    final path = pathData.path
        .map((node) => LatLng(node.latitude, node.longitude))
        .toList();

    const mediumBlue = "#1487C8";
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
      strokeStyle: "shortdot",
    );

    final endLine = Polyline(
      path: [path.last, end],
      strokeWeight: 5,
      strokeColor: mediumBlue,
      strokeOpacity: 1,
      strokeStyle: "shortdot",
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
      image: "https://kaist-map.github.io/Kaist-Map-App/map_pin_red.png",
      draggable: false,
      importance: 128,
      onTap: () {},
    );

    _polylines = [pathPolyline, startLine, endLine];
    setMarkers([startMarker, endMarker]);

    _pathETA = pathData.getETA(
      wantBeam: wantBeam,
      wantFreeOfRain: wantFreeOfRain,
    );
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

    if (!markers.any((marker) => marker.name == "building-${building.id}")) {
      return;
    }

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
