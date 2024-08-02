import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigatorKey;

  void pop() => _navigatorKey.currentState!.pop();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }
}