import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/spec/colors.dart';

import 'widget/resetPasswordWidget.dart';

class ResetPassword extends StatefulWidget {
  final String? userId;

  ResetPassword({this.userId});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = new TextEditingController();
  final _newPasswordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();

  FocusNode? _newPasswordFocusNode,
      _confirmPasswordFocusNode,
      _passwordFocusNode;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = new FocusNode();
    _newPasswordFocusNode = new FocusNode();
    _confirmPasswordFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode!.dispose();
    _newPasswordFocusNode!.dispose();
    _confirmPasswordFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          resetPasswordWidget(
            context: context,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            newPasswordFocusNode: _newPasswordFocusNode,
            confirmPasswordFocusNode: _confirmPasswordFocusNode,
            key: _formKey,
            passwordController: _passwordController,
            passwordFocusNode: _passwordFocusNode,
            onResetPassword: () => _onResetPassword(),
            showCurrentPassword: widget.userId == null,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onResetPassword() async {
    _passwordFocusNode!.unfocus();
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
          endPoint: widget.userId == null
              ? RESETPASSWORD_URL
              : ADMINRESETPASSWORD_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: widget.userId == null
              ? {
                  'email': userModel!.data!.user!.email!,
                  'current_password': _passwordController.text,
                  "password": _newPasswordController.text,
                  "password_confirmation": _confirmPasswordController.text,
                }
              : {
                  'userid': widget.userId,
                  'createuser': userModel!.data!.user!.userid,
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
        navigation(context: context, pageName: 'back');
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
