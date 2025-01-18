import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/constant/map.dart';

class MapContext extends ChangeNotifier {
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  void setMarkers(Set<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  CameraPosition _cameraPosition = const CameraPosition(
    target: KaistLocation.location,
    zoom: KaistLocation.zoom,
  );
  CameraPosition get cameraPosition => _cameraPosition;

  void setCameraPosition(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
    notifyListeners();
  }

  void Function(LatLng) onTap = (LatLng latLng) {};

  void setOnTap(void Function(LatLng) onTap) {
    this.onTap = onTap;
    notifyListeners();
  }
}