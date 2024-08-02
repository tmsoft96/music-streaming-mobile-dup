import 'package:flutter/material.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/utils/webBrowser/webBrower.dart';

import 'widget/othersWidget.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({Key? key}) : super(key: key);

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: othersWidget(
        context: context,
        onEditProfile: () => navigation(context: context, pageName: "account"),
        onAboutUs: () => _onNavigateToWeb(ABOUTUS_URL, "About Us"),
        onAccount: () => navigation(context: context, pageName: "account"),
        onContactUs: () => _onNavigateToWeb(CONTACTUS_URL, "Contact Us"),
        onEnroll: () => navigation(context: context, pageName: "enroll"),
        onOurServices: () => _onNavigateToWeb(OURSERVICE_URL, "Our Service"),
        onInviteFriend: () => inviteFrinds(),
        onLegal: () => navigation(context: context, pageName: "legal"),
      ),
    );
  }

  void _onNavigateToWeb(String uri, String pageTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebBrowser(
          previousPage: 'back',
          title: pageTitle,
          url: uri,
        ),
      ),
    );
  }
}
