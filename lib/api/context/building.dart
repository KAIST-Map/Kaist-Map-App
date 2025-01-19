import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/all_building.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/local/bookmarks.dart';

class ApiContext extends ChangeNotifier {
  final Completer<List<BuildingData>> _buildings = Completer<List<BuildingData>>();
  Completer<List<BuildingData>> _bookmarks = Completer<List<BuildingData>>();

  ApiContext() {
    _initialize();
  }

  void _initialize() async {
    try {
      _buildings.complete(await AllBuildingLoader().fetch());
      _bookmarks.complete(
        await BookmarksLoader()
          .fetch()
          .then((ids) => 
            _buildings.future.then((buildings) => 
              buildings.where((building) => ids.contains(building.id)).toList()
            )));
    } catch (e) {
      _buildings.completeError(e);
    }
  }

  Future<List<BuildingData>> get buildings => _buildings.future;
  Future<List<BuildingData>> get bookmarks => _bookmarks.future;

  void removeBookmark(int id) {
    _bookmarks.future.then((bookmarks) {
      bookmarks.remove(bookmarks.firstWhere((building) => building.id == id));
      _bookmarks = Completer<List<BuildingData>>()..complete(bookmarks);
      notifyListeners();
    });
  }

  void addBookmark(BuildingData building) {
    _bookmarks.future.then((bookmarks) {
      bookmarks.add(building);
      _bookmarks = Completer<List<BuildingData>>()..complete(bookmarks);
      notifyListeners();
    });
  }
}