import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:provider/provider.dart';

class KMapBookmarks extends StatelessWidget {
  const KMapBookmarks({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarksContext = context.read<ApiContext>().bookmarks;
    final mapContext = context.read<MapContext>();

    late final List<BuildingData> bookmarks;

    return FutureBuilder<void>(
      future: bookmarksContext.then(
        (bookmarksContext) {
          bookmarks = bookmarksContext;
          mapContext.setMarkers(bookmarksContext.map((building) => building.toMarker(onTap: () {})).toSet());
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: Text(bookmarks.toString()));
        }
      },
    );
  }
}
