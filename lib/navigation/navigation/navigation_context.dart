import 'package:flutter/foundation.dart';

class RoutingContext extends ChangeNotifier {
  String _currentRoute = '/';

  String get currentRoute => _currentRoute;

  void updateRoute(String newRoute) {
    if (newRoute != _currentRoute) {
      _currentRoute = newRoute;
      notifyListeners();
    }
  }
}