import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/local/search_history.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatelessWidget {
  final BuildingData buildingData;
  final bool isHistory;
  final void Function(BuildingData)? onTap;

  const SearchResult(
      {super.key,
      required this.buildingData,
      required this.isHistory,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final mapContext = context.read<MapContext>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(buildingData);
          } else {
            mapContext.lookAt(buildingData);
          }
          Navigator.of(context).pop();
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          title: Text(buildingData.name),
          subtitle:
              Text(buildingData.categoryIds.map((e) => e.name).join(', ')),
          trailing: isHistory
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: KMapColors.darkGray.shade500,
                  ),
                  onPressed: () {
                    SearchHistoryRemover(buildingData.id).fetch();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
