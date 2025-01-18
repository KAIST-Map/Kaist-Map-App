import 'package:flutter/material.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/component/building_filter.dart';

class KMapSearch extends StatelessWidget {
  const KMapSearch({
    super.key,
  });

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
              hintText: '어디로 가고 싶으신가요?',
              leading: const Icon(Icons.search),
            ),
          ),
        );
      },
      viewBackgroundColor: KMapColors.darkBlue.shade100,
      viewHintText: '어디로 가고 싶으신가요?',
      suggestionsBuilder: (context, controller) {
        return List<ListTile>.generate(20, (index) {
          return ListTile(
            title: Text('Suggestion ${index+1}'),
            onTap: () {
              controller.text = 'Suggestion $index';
            },
          );
        });
      },
      viewBuilder: (suggestions) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: KMapColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),
              const BuildingCategoryFilter(),
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
      },
    );
  }
}
