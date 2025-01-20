import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/api/building/search.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:kaist_map/api/local/search_history.dart';
import 'package:kaist_map/component/search/result.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/component/building_filter.dart';
import 'package:provider/provider.dart';

class KMapSearch extends StatefulWidget {
  const KMapSearch({
    super.key,
  });

  @override
  State<KMapSearch> createState() => _KMapSearchState();
}

class _KMapSearchState extends State<KMapSearch> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.openView();
          },
          child: IgnorePointer(
            child: SearchBar(
              controller: controller,
              hintText: '어디를 찾으시나요?',
              leading: const Icon(Icons.search, color: KMapColors.white),
            ),
          ),
        );
      },
      viewHintText: '어디를 찾으시나요?',
      suggestionsBuilder: (context, controller) {
        return suggestionsBuilder(context, controller, () => setState(() {}));
      },
      viewBuilder: (suggestions) {
        return SearchView(suggestions: suggestions);
      },
    );
  }
}

Future<Iterable<Widget>> suggestionsBuilder(
    BuildContext context, SearchController controller, VoidCallback setState,
    {void Function(BuildingData)? onResultTap}) async {
  if (controller.text.isEmpty) {
    final historyIds = SearchHistoryFetcher().fetch();
    final buildings = context.read<BuildingContext>().buildings;
    final historyBuildings =
        await Future.wait([historyIds, buildings]).then((value) {
      final history = value[0] as List<int>;
      final buildings = value[1] as List<BuildingData>;
      return history
          .where((id) => buildings.any((building) => building.id == id))
          .map((id) => buildings.firstWhere((building) => building.id == id))
          .toList();
    });

    return historyBuildings
        .map((buildingData) => SearchResult(
            onTap: onResultTap,
            buildingData: buildingData,
            isHistory: true,
            setState: setState))
        .toList();
  }

  final searchQuery = controller.text;
  final searchBuilding = await BuildingSearchLoader(name: searchQuery).fetch();

  return searchBuilding
      .map((buildingData) => SearchResult(
            buildingData: buildingData,
            isHistory: false,
            setState: setState,
          ))
      .toList();
}

class SearchView extends StatelessWidget {
  final Iterable<Widget> suggestions;

  const SearchView({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: KMapColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: BuildingCategoryFilter(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return suggestions.elementAt(index);
              },
              itemCount: suggestions.length,
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
