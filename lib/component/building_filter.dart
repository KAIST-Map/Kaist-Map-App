import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/component/chip.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:provider/provider.dart';

class BuildingCategoryFilterContext extends ChangeNotifier {
  List<BuildingCategory> _filters = [];

  List<BuildingCategory> get filters => _filters;

  void setFilters(List<BuildingCategory> filters) {
    _filters = filters;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Iterable<BuildingData> applyFilters(Iterable<BuildingData> buildings) {
    if (_filters.isEmpty) {
      return buildings;
    }
    return buildings.where((building) =>
        _filters.any((category) => building.categories.contains(category)));
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
        children: [
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(Size.zero),
              backgroundColor: filters.isEmpty
                  ? null
                  : WidgetStateProperty.all(KMapColors.darkBlue),
              elevation: WidgetStateProperty.all(2.5),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
            ),
            onPressed: () {
              setFilters([]);
            },
            child: filters.isEmpty
                ? const Icon(
                    Icons.filter_alt_off,
                    color: KMapColors.darkBlue,
                  )
                : Row(
                    children: [
                      const Icon(
                        Icons.filter_alt,
                        color: KMapColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(filters.length.toString(),
                          style: const TextStyle(
                              color: KMapColors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(Icons.close, color: KMapColors.white),
                    ],
                  ),
          ),
          ...BuildingCategory.values.map((category) {
            final selected = filters.contains(category);
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: KMapChip(
                isSelected: selected,
                onChange: (selected) {
                  if (selected) {
                    setFilters([...filters, category]);
                  } else {
                    setFilters(filters.where((e) => e != category).toList());
                  }
                },
                category: category,
              ),
            );
          })
        ],
      ),
    );
  }
}
