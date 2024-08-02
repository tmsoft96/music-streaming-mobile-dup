import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/auth/appleService.dart';
import 'package:rally/config/auth/googleService.dart';
import 'package:rally/config/checkConnection.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/config/sharePreference.dart';
import 'package:rally/models/userModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/spec/strings.dart';

import '../authentication/register/registerAccount.dart';
import 'widget/onboardingWidget.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  GoogleService _googleService = new GoogleService();
  AppleService _appleService = new AppleService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            onboardingWidget(
              context: context,
              onLogin: () => navigation(context: context, pageName: "login"),
              onApple: () => _onApple(),
              onGoogle: () => _onGoogle(),
              onRegister: () => navigation(
                context: context,
                pageName: 'register',
              ),
            ),
            if (_isLoading) customLoadingPage(),
          ],
        ),
      ),
    );
  }

  Future<void> _onGoogle() async {
    try {
      setState(() => _isLoading = true);
      checkConnection().then((online) {
        if (online) {
          _googleService.googleSignIn().then((User? user) async {
            print(user);
            _onLogin(email: user!.email, uid: user.uid);
          }).catchError((e) {
            print(e);
            toastContainer(
              text: "Your google account cannot be access now",
              backgroundColor: RED,
            );
            setState(() => _isLoading = false);
          });
        } else {
          toastContainer(text: NOINTERNET, backgroundColor: RED);
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      print(e);
      toastContainer(text: "$e", backgroundColor: RED);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onApple() async {
    try {
      checkConnection().then((online) {
        if (online) {
          _appleService.appleSignIn().then((Map<String, dynamic>? value) async {
            UserCredential firebaseUser = value!["firebase"];
            await _onLogin(
              email: firebaseUser.user!.email,
              uid: firebaseUser.user!.uid,
            );
          }).catchError((e) {
            toastContainer(text: e.toString(), backgroundColor: RED);
            setState(() => _isLoading = false);
          });
        } else {
          toastContainer(text: NOINTERNET, backgroundColor: RED);
          setState(() => _isLoading = false);
        }
      });
    } catch (e) {
      print(e);
      toastContainer(text: e.toString(), backgroundColor: RED);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onLogin({
    @required String? email,
    @required String? uid,
  }) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: LOGIN_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          'email': email,
          'password': DEFAULTPASSWORD,
        },
      ),
      showToastMsg: false,
    );
    if (httpResult['ok']) {
      await saveHive(
        key: "userDetails",
        data: jsonEncode(httpResult['data']),
      );
      await getAllOtherFiles(state: (String text) {  });
      userModel = UserModel.fromJson(httpResult['data']);
      await continueSignUpOnFirebase(
        firebaseUserId: uid,
        userModel: userModel,
      );
      await saveBoolShare(key: "auth", data: true);
      // toastContainer(
      //   text: httpResult["data"]["msg"],
      //   backgroundColor: GREEN,
      // );
      // setState(() => _isLoading = false);
      navigation(context: context, pageName: 'homepage');
    } else {
      setState(() => _isLoading = false);
      // if (httpResult["statusCode"] == 200) {

      // } else {
      //   toastContainer2(
      //     context: context,
      //     text: httpResult["error"],
      //     backgroundColor: RED,
      //   );
      // }
      _registerUserInstead(email: email, uid: uid);
    }
  }

  void _registerUserInstead({
    @required String? email,
    @required String? uid,
  }) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      backgroundColor: PRIMARYCOLOR,
      text: 'Seems your "$email" is new, create account instead',
      confirmBtnText: 'Register',
      cancelBtnText: 'Cancel',
      confirmBtnColor: PRIMARYCOLOR,
      onConfirmBtnTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(email: email, uid: uid),
          ),
        );
      },
    );
  }
}
