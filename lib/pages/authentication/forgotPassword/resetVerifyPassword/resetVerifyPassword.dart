import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/spec/colors.dart';

import 'widget/resetVerifyPasswordWidget.dart';

class ResetVerifyPassword extends StatefulWidget {
  final String? email;

  ResetVerifyPassword(this.email);

  @override
  _ResetVerifyPasswordState createState() => _ResetVerifyPasswordState();
}

class _ResetVerifyPasswordState extends State<ResetVerifyPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _newPasswordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();

  FocusNode? _newPasswordFocusNode, _confirmPasswordFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode = new FocusNode();
    _confirmPasswordFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordFocusNode!.dispose();
    _confirmPasswordFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          resetVerifyPasswordWidget(
            context: context,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            newPasswordFocusNode: _newPasswordFocusNode,
            confirmPasswordFocusNode: _confirmPasswordFocusNode,
            key: _formKey,
            onResetPassword: () => _onResetPassword(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onResetPassword() async {
    _confirmPasswordFocusNode!.unfocus();
    _newPasswordFocusNode!.unfocus();
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        toastContainer(text: "New password not match", backgroundColor: RED);
        return;
      }

      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: RESETVEFIRYPASSWORD_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            'email': widget.email,
            "password": _newPasswordController.text,
            "password_confirmation": _confirmPasswordController.text,
          },
        ),
        showToastMsg: false,
      );
      if (httpResult['ok']) {
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: GREEN,
        );
        setState(() => _isLoading = false);
        navigation(context: context, pageName: 'login');
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
}
