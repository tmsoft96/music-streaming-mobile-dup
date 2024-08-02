import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
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

import '../verifyAccount/verifyAccount.dart';
import 'widget/loginWidget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  FocusNode? _emailFocusNode, _passwordFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode!.dispose();
    _passwordFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          loginWidget(
            context: context,
            emailController: _emailController,
            emailFocusNode: _emailFocusNode,
            key: _formKey,
            onForgetPassword: () => navigation(
              context: context,
              pageName: "forgotPassword",
            ),
            passwordController: _passwordController,
            passwordFocusNode: _passwordFocusNode,
            onLogin: () => _onLogin(),
            onSignUp: () => navigation(context: context, pageName: 'register'),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onLogin() async {
    _emailFocusNode!.unfocus();
    _passwordFocusNode!.unfocus();
    _emailController.text = _emailController.text.trim();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: LOGIN_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        ),
        showToastMsg: false,
      );
      if (httpResult['ok']) {
        await saveHive(
          key: "userDetails",
          data: jsonEncode(httpResult['data']),
        );
        userModel = UserModel.fromJson(httpResult['data']);
        await getAllOtherFiles(state: (String text) {  });
        await continueSignUpOnFirebase(
          firebaseUserId: null,
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
        // if (httpResult["statusCode"] != 200) {
        //   toastContainer(
        //     text: httpResult["error"],
        //     backgroundColor: RED,
        //   );
        // } else {
        if (httpResult["data"] != null &&
            httpResult["data"]["msg"]
                .toString()
                .toLowerCase()
                .contains("verify")) {
          toastContainer(
            text: httpResult["data"]["msg"],
            backgroundColor: RED,
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => VerifyAccount(
                password: _passwordController.text,
                email: _emailController.text,
                token: httpResult["data"]["token"],
              ),
            ),
            (Route<dynamic> route) => false,
          );
        } else
          toastContainer(
            text: httpResult["error"],
            backgroundColor: RED,
          );
        // }
      }
    }
  }
}
