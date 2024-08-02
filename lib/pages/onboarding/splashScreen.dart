import 'package:rally/providers/checkUpdateProvider.dart';
import 'package:rally/spec/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/spec/styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadPercent = "0";

  @override
  void initState() {
    super.initState();
    checkUpdate();
    checkSession((String loadPercent) {
      _loadPercent = loadPercent;
      setState(() {});
    }).then((status) async {
      print(status);
      if (status == "auth") {
        navigation(context: context, pageName: "homepage");
      } else {
        //check if user is authenticated
        navigation(context: context, pageName: "onboardingpage");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(LOGO),
            SizedBox(height: 50),
            Text("The Hub for fresh music", style: h4WhiteBold),
            SizedBox(height: 20),
            Text("$_loadPercent%", style: h4WhiteBold),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          VERSION,
          style: h5White,
        ),
      ),
    );
  }
}
