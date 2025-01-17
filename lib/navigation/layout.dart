import 'package:flutter/material.dart';
import 'package:kaist_map/navigation/explore/widget.dart';
import 'package:kaist_map/navigation/google_map/map_context.dart';
import 'package:kaist_map/navigation/google_map/widget.dart';
import 'package:provider/provider.dart';

class KMapNavigation extends StatelessWidget {
  const KMapNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final mapContext = context.watch<MapContext>();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const KMapGoogleMap(),
          _getSelectedWidget(mapContext.selectedIndex),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: mapContext.setSelectedIndex,
        selectedIndex: mapContext.selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on_outlined),
            label: '탐색',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_outline),
            label: '즐겨찾기',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: '설정',
          ),
        ],
      ),
    );
  }

  Widget _getSelectedWidget(int index) {
    switch (index) {
      case 0:
        return const Center(child: KMapExplore());
      case 1:
        return const Center(child: Text('즐겨찾기'));
      case 2:
        return const Center(child: Text('설정 페이지'));
      default:
        return const Center(child: Text('탐색 페이지'));
    }
  }
}
