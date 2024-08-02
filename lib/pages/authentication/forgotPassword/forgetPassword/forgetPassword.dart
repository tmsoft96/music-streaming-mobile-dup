import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/services.dart';
import 'package:rally/pages/authentication/forgotPassword/verifyPin/verifyPin.dart';
import 'package:rally/spec/colors.dart';

import 'widget/forgetPasswordWidget.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();

  FocusNode? _emailFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          forggetPasswordWidget(
            emailController: _emailController,
            emailFocusNode: _emailFocusNode,
            context: context,
            key: _formKey,
            onSubmit: () => _onSubmit(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onSubmit() async {
    _emailFocusNode!.unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: FORGOTPASSWORD_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "email": _emailController.text,
          },
        ),
        showToastMsg: false,
      );
      log("$httpResult");
      if (httpResult["ok"]) {
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: GREEN,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyPin(
              email: _emailController.text,
            ),
          ),
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
  }
}
