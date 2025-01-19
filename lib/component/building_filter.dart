import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/component/chip.dart';
import 'package:provider/provider.dart';

class BuildingCategoryFilterContext extends ChangeNotifier {
  List<BuildingCategory> _filters = [];

  List<BuildingCategory> get filters => _filters;

  void setFilters(List<BuildingCategory> filters) {
    _filters = filters;
    notifyListeners();
  }
}

class BuildingCategoryFilter extends StatelessWidget {
  const BuildingCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = context.watch<BuildingCategoryFilterContext>().filters;
    final setFilters = context.read<BuildingCategoryFilterContext>().setFilters;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: BuildingCategory.values.map((category) {
          final selected = filters.contains(category);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: KMapChip(
              isSelected: selected,
              onChange: (selected) {
                if (selected) {
                  setFilters([...filters, category]);
                } else {
                  setFilters(filters.where((e) => e != category).toList());
                }
              }, category: category,
            ),
          );
        }).toList(),
      ),
    );
  }
}
