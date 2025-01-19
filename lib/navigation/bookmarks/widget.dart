import 'package:flutter/material.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/api/local/bookmarks.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:provider/provider.dart';

class KMapBookmarks extends StatelessWidget {
  const KMapBookmarks({super.key});

  @override
  Widget build(BuildContext context) {
    final mapContext = context.read<MapContext>();
    final buildingContext = context.watch<BuildingContext>();
    final Future<List<int>> bookmarks = BookmarksFetcher().fetch(mock: false);

    return FutureBuilder<void>(
      future: bookmarks.then(
        (bookmarks) async {
          final buildings = await buildingContext.buildings;
          mapContext.setMarkers(
            bookmarks.map((buildingId) => 
                buildings.firstWhere((building) => building.id == buildingId).toMarker(
                  pageName: "bookmarks",
                  onTap: () {}))
            .toSet());
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Container();
        }
      },
    );
  }
}
