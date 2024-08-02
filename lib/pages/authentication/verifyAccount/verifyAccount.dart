import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/config/sharePreference.dart';
import 'package:rally/models/userModel.dart';
import 'package:rally/spec/colors.dart';

import 'widget/verifyAcountWidget.dart';

class VerifyAccount extends StatefulWidget {
  final String? email, password, token;

  VerifyAccount({
    @required this.email,
    @required this.password,
    @required this.token,
  });

  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final codeController = new TextEditingController();

  FocusNode? codeFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    codeFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    codeFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          verifyAcountWidget(
            codeController: codeController,
            codeFocusNode: codeFocusNode,
            context: context,
            key: _formKey,
            onVerify: () => _onVerify(),
            onResend: () => _onResend(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onResend() async {
    codeFocusNode!.unfocus();
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: RESENDPIN_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "email": widget.email,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      setState(() => _isLoading = false);
      toastContainer(
        text: httpResult["data"]["msg"],
        backgroundColor: GREEN,
      );
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"],
              backgroundColor: RED,
            )
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  Future<void> _onVerify() async {
    codeFocusNode!.unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: VERIFY_URL,
          method: HTTPMETHOD.POST,
          tempHeader: widget.token,
          httpPostBody: {
            "email": widget.email,
            "token": codeController.text,
          },
        ),
        showToastMsg: false,
      );
      log("$httpResult");
      if (httpResult["ok"]) {
        // toastContainer(
        //   text: httpResult["data"]["msg"],
        //   backgroundColor: GREEN,
        // );
        _onLogin();
      } else {
        setState(() => _isLoading = false);
        httpResult["statusCode"] == 200
            ? toastContainer(
                text: httpResult["data"]["msg"],
                backgroundColor: RED,
              )
            : toastContainer(text: httpResult["error"], backgroundColor: RED);
      }
    }
  }

  Future<void> _onLogin() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: LOGIN_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          'email': widget.email,
          'password': widget.password,
        },
      ),
    );
    if (httpResult['ok']) {
      await saveHive(
        key: "userDetails",
        data: jsonEncode(httpResult['data']),
      );
      userModel = UserModel.fromJson(httpResult['data']);
      await getAllOtherFiles(state: (String text) {  });
      // await continueSignUpOnFirebase(
      //   user: user,
      //   userModel: userModel,
      // );
      await saveBoolShare(key: "auth", data: true);
      // toastContainer(
      //   text: httpResult["data"]["msg"],
      //   backgroundColor: GREEN,
      // );
      setState(() => _isLoading = false);
      navigation(context: context, pageName: 'homepage');
    } else {
      setState(() => _isLoading = false);
      if (httpResult["statusCode"] == 200) {
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: RED,
        );
      } else {
        toastContainer(
          text: httpResult["error"],
          backgroundColor: RED,
        );
      }
    }
  }
}
