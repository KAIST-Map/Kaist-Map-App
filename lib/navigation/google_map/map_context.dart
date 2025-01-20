import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/api/building/data.dart';
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

  void showTwoLocations(LatLng location1, LatLng location2) {
    if (_mapController == null) {
      return;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(
        (location1.latitude < location2.latitude
                ? location1.latitude
                : location2.latitude) -
            0.003,
        (location1.longitude < location2.longitude
                ? location1.longitude
                : location2.longitude) -
            0.0004,
      ),
      northeast: LatLng(
        (location1.latitude > location2.latitude
                ? location1.latitude
                : location2.latitude) +
            0.003,
        (location1.longitude > location2.longitude
                ? location1.longitude
                : location2.longitude) +
            0.0004,
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
  }

  void Function(LatLng) onTap = (LatLng latLng) {};

  void setOnTap(void Function(LatLng) onTap) {
    this.onTap = onTap;
    notifyListeners();
  }

  void lookAt(BuildingData building) {
    if (_mapController == null) {
      return;
    }

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            building.latitude - 0.0002,
            building.longitude,
          ),
          zoom: 18,
        ),
      ),
    );

    if (!markers.any((marker) =>
        marker.markerId.value.split('-').last == building.id.toString())) {
      return;
    }

    final marker = markers.firstWhere((marker) =>
        marker.markerId.value.split('-').last == building.id.toString());
    mapController?.showMarkerInfoWindow(marker.markerId);
    marker.onTap?.call();
  }
}
