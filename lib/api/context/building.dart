import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/all_building.dart';
import 'package:kaist_map/api/building/data.dart';

class BuildingContext extends ChangeNotifier {
  final Completer<List<BuildingData>> _buildings =
      Completer<List<BuildingData>>();

  BuildingContext() {
    _loadBuildings();
  }

  void _loadBuildings() async {
    try {
      _buildings.complete(await AllBuildingLoader().fetch(mock: false));
    } catch (e) {
      _buildings.completeError(e);
    }
  }

  Future<List<BuildingData>> get buildings => _buildings.future;
}
