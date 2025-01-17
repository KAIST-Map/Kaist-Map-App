import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapContext extends ChangeNotifier {
  GoogleMapController? _mapController;
  int _selectedIndex = 0;

  GoogleMapController? get mapController => _mapController;
  int get selectedIndex => _selectedIndex;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}