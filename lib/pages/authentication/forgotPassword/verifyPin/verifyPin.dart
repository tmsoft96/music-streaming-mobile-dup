import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/services.dart';
import 'package:rally/pages/authentication/forgotPassword/resetVerifyPassword/resetVerifyPassword.dart';
import 'package:rally/pages/authentication/verifyAccount/widget/verifyAcountWidget.dart';
import 'package:rally/spec/colors.dart';

class VerifyPin extends StatefulWidget {
  final String? email;

  VerifyPin({@required this.email});

  @override
  _VerifyPinState createState() => _VerifyPinState();
}

class _VerifyPinState extends State<VerifyPin> {
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
            isVerifyPin: true,
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
          endPoint: VERIFYPIN_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "email": widget.email,
            "token": codeController.text,
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
            builder: (context) => ResetVerifyPassword(widget.email),
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
