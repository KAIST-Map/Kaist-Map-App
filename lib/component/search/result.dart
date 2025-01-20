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
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 8, 0),
          title: Text(buildingData.name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          subtitle: buildingData.alias.isNotEmpty
              ? Text(
                  buildingData.alias.map((a) => "#$a").join("  "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12,
                      color: KMapColors.darkBlue,
                      fontWeight: FontWeight.w400),
                )
              : null,
          trailing: isHistory
              ? IconButton(
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.close,
                    color: KMapColors.darkGray.shade500,
                    size: 16,
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
