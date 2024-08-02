import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';
import 'package:rally/config/navigation.dart';

import 'widget/updateAppWidget.dart';

bool forceUser = false;

class UpdateApp extends StatelessWidget {
  final bool? force, allowNotNow;
  final String? message, title;

  UpdateApp({
    @required this.force,
    @required this.message,
    @required this.title,
    @required this.allowNotNow,
  });

  @override
  Widget build(BuildContext context) {
    forceUser = force!;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: updateAppWidget(
          context: context,
          title: title,
          message: message,
          allowNotNow: allowNotNow,
          onNotNow: () => _onNotNow(context),
          onUpdate: () => _onUpdate(),
        ),
      ),
    );
  }

  void _onNotNow(BuildContext context) =>
      navigation(context: context, pageName: "homepage");

  Future<void> _onUpdate() async {
    OpenStore.instance.open(
      appStoreId: "1625565797",
      androidAppBundleId: "com.cc77Developers.rally",
    );
  }
}
