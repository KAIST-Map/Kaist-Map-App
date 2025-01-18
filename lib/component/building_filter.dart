import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/constant/colors.dart';
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
            padding: const EdgeInsets.only(right: 8.0),
            child: Hero(
              tag: "category_filter_chip_${category.toString()}",
              child: FilterChip(
                side: BorderSide(
                    color: selected
                        ? KMapColors.darkBlue
                        : KMapColors.darkBlue.shade100),
                elevation: 2,
                label: Text(category.name),
                selected: selected,
                onSelected: (selected) {
                  if (selected) {
                    filters.add(category);
                  } else {
                    filters.remove(category);
                  }
                  setFilters(filters);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
