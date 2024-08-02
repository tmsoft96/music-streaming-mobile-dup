import 'package:flutter/material.dart';
import 'package:rally/pages/modules/updateApp/updateApp.dart';
import 'package:rally/routes/routeName.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case UpdateViewRoute:
      Map<dynamic, dynamic>? postToEdit = settings.arguments as Map?;
      print(postToEdit);
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: UpdateApp(
          force: postToEdit!["force"],
          message: postToEdit["message"],
          title: postToEdit["title"],
          allowNotNow: postToEdit["allowNotNow"],
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({
  @required String? routeName,
  @required Widget? viewToShow,
}) {
  return MaterialPageRoute(
      settings: RouteSettings(name: routeName), builder: (_) => viewToShow!);
}
