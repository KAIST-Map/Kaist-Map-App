import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaist_map/api/building/data.dart';
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

  List<Marker> _markers = [];
  List<Marker> get markers => _markers;
  List<List<Marker>> _showingMarkers = [[], [], [], [], [], []];
  List<List<Marker>> get showingMarkers => _showingMarkers;
  List<Polyline> _polylines = [];
  List<Polyline> get polylines => _polylines;
  int _zoomLevel = 4;
  int get zoomLevel => _zoomLevel;

  LatLng? _myLocation;
  LatLng? get myLocation => _myLocation;
  Marker? get myLocationMarker => _myLocation != null
      ? Marker(
          name: "my-position",
          lat: _myLocation!.latitude,
          lng: _myLocation!.longitude,
          width: 20,
          height: 20,
          offsetY: 10,
          image:
              "https://kaist-map.github.io/Kaist-Map-App/my_location_pin.png",
          draggable: false,
          importance: 99,
          onTap: () {})
      : null;

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
          if (a.image.contains("green") || a.image.contains('red')) {
            return (0).compareTo(-1);
          }
          if (b.image.contains("green") || b.image.contains('red')) {
            return (-1).compareTo(0);
          }
          return b.importance.compareTo(a.importance);
        });
        final List<IsolateMarker> showingMarkers = [];

        for (var i = 0; i < message.markers.length; i++) {
          () {
            for (var j = 0; j < showingMarkers.length; j++) {
              if (message.markers[i].distanceToMeters(showingMarkers[j]) <
                  (omitMarkersDistanceInMeters.elementAtOrNull(message.zoomLevel) ?? 0)) {
                return;
              }
            }
            showingMarkers.add(message.markers[i]);
          }();
        }

        return showingMarkers;
      }, ComputeMessage.fromMarkersZoom([...markers], zoomLevel));

      print("zoomLevel: $zoomLevel, showingMarkers: ${isolateMarkers.map((m) => m.name).toList().toString().replaceAll('building-', '')}");

      return isolateMarkers.map((marker) => Marker(
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
          )).toList();
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
      image: "https://kaist-map.github.io/Kaist-Map-App/map_pin_red.png",
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
