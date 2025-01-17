import 'package:flutter/material.dart';
import 'package:kaist_map/kakaomap/kakao_map_widget.dart';

class KMapNavigation extends StatefulWidget {
  const KMapNavigation({super.key});

  @override
  State<KMapNavigation> createState() => _KMapNavigationState();
}

class _KMapNavigationState extends State<KMapNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getSelectedWidget(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
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
        return const KakaoMapWidget();
      case 1:
        return const Text('즐겨찾기');
      case 2:
        return const Text('설정 페이지');
      default:
        return const Text('탐색 페이지');
    }
  }
}
