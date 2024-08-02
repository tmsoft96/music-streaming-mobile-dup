import 'package:flutter/material.dart';
import 'package:rally/config/services.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/webBrowser/webBrower.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Legal")),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        color: PRIMARYCOLOR1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () => _onNavigateToWeb(
                TERMSANDCONDITION_URL,
                "Terms and Condition",
                context,
              ),
              title: Text("Terms and condition", style: h4White),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
            ),
            Divider(color: WHITE),
            ListTile(
              onTap: () => _onSoftwareLicenses(context),
              title: Text("Software Licenses", style: h4White),
              trailing: Icon(Icons.arrow_forward_ios, color: BLACK),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigateToWeb(String uri, String pageTitle, BuildContext context) {
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

  void _onSoftwareLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationIcon: Image.asset(LOGO),
    );
  }
}
