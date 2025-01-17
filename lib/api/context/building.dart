import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/all_building.dart';
import 'package:kaist_map/api/building/data.dart';

class BuildingContext extends ChangeNotifier {
  BuildingContext() {
    _loadBuildings();
  }

  List<BuildingData> _buildings = [];

  List<BuildingData> get buildings => _buildings;

  void _loadBuildings() {
    AllBuildingLoader().fetch().then((buildings) {
      _buildings = buildings;
      notifyListeners();
    });
  }
}