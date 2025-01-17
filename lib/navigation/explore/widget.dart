import 'package:flutter/material.dart';
import 'package:kaist_map/api/context/building.dart';
import 'package:provider/provider.dart';

class KMapExplore extends StatefulWidget {
  const KMapExplore({super.key});

  @override
  State<KMapExplore> createState() => _KMapExploreState();
}

class _KMapExploreState extends State<KMapExplore> {
  @override
  Widget build(BuildContext context) {
    final BuildingContext buildingContext = context.watch<BuildingContext>();
    print(buildingContext.buildings.map((building) => building.name));
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SearchAnchor(builder: (context, controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 20.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            }, suggestionsBuilder: (context, controller) {
              return List<ListTile>.generate(5, (index) {
                return ListTile(
                  title: Text('Suggestion $index'),
                  onTap: () {
                    controller.text = 'Suggestion $index';
                  },
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}
