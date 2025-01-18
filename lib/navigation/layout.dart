import 'package:flutter/material.dart';
import 'package:kaist_map/navigation/bookmarks/widget.dart';
import 'package:kaist_map/navigation/map/widget.dart';
import 'package:kaist_map/navigation/google_map/widget.dart';
import 'package:kaist_map/navigation/my/widget.dart';
import 'package:provider/provider.dart';

class NavigationContext extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void _setSelectedIndex(int index) {
    _selectedIndex = index;
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
        onDestinationSelected: navigationContext._setSelectedIndex,
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
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: '내 정보',
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
        return const KMapMyPage();
      default:
        return const Center(child: Text('탐색 페이지'));
    }
  }
}
