import 'package:flutter/material.dart';
import 'package:kaist_map/navigation/bookmarks/widget.dart';
import 'package:kaist_map/navigation/map/widget.dart';
import 'package:kaist_map/navigation/google_map/widget.dart';
import 'package:kaist_map/navigation/routing/widget.dart';
import 'package:provider/provider.dart';

class NavigationContext extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}

class KMapNavigation extends StatelessWidget {
  const KMapNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationContext = context.watch<NavigationContext>();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const KMapGoogleMap(),
          _getSelectedBodyWidget(navigationContext.selectedIndex),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: navigationContext.setSelectedIndex,
        selectedIndex: navigationContext.selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: '지도',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_outline),
            label: '즐겨찾기',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.directions),
            icon: Icon(Icons.directions_outlined),
            label: '길찾기',
          ),
        ],
      ),
    );
  }

  Widget _getSelectedBodyWidget(int index) {
    switch (index) {
      case 0:
        return const KMapMap();
      case 1:
        return const KMapBookmarks();
      case 2:
        return const KMapRoutingPage();
      default:
        return const Center(child: Text('올바르지 않은 요청입니다.'));
    }
  }
}
