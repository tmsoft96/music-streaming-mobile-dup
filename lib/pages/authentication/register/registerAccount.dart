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
import 'package:rally/pages/authentication/register/widget/registerAccountWidget.dart';
import 'package:rally/pages/authentication/verifyAccount/verifyAccount.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';

class RegisterPage extends StatefulWidget {
  final String? email, uid;

  RegisterPage({this.email, this.uid});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _comfPassController = new TextEditingController();
  final _fNameController = new TextEditingController();
  final _lNameController = new TextEditingController();

  bool _isLoading = false;

  FocusNode? _phoneFocusNode,
      _emailFocusNode,
      _fNameFocusNode,
      _lNameFocusNode,
      _passwordFocusNode,
      _comfPassfocusNode;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode = new FocusNode();
    _emailFocusNode = new FocusNode();
    _passwordFocusNode = new FocusNode();
    _comfPassfocusNode = new FocusNode();
    _fNameFocusNode = new FocusNode();
    _lNameFocusNode = new FocusNode();

    if (widget.email != null && widget.uid != null) {
      _emailController.text = widget.email!;
      _passwordController.text = DEFAULTPASSWORD;
      _comfPassController.text = DEFAULTPASSWORD;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _phoneFocusNode!.dispose();
    _emailFocusNode!.dispose();
    _passwordFocusNode!.dispose();
    _comfPassfocusNode!.dispose();
    _fNameFocusNode!.dispose();
    _lNameFocusNode!.dispose();
  }

  void _unfocusAllNode() {
    _phoneFocusNode!.unfocus();
    _emailFocusNode!.unfocus();
    _passwordFocusNode!.unfocus();
    _comfPassfocusNode!.unfocus();
    _fNameFocusNode!.unfocus();
    _lNameFocusNode!.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          registerAccountWidget(
            emailController: _emailController,
            passwordController: _passwordController,
            comfPassController: _comfPassController,
            passwordFocusNode: _passwordFocusNode,
            emailFocusNode: _emailFocusNode,
            comfPassfocusNode: _comfPassfocusNode,
            key: _formKey,
            context: context,
            onCreateAccount: () => _onRegister(),
            fNameController: _fNameController,
            lNameController: _lNameController,
            fNameFocusNode: _fNameFocusNode,
            lNameFocusNode: _lNameFocusNode,
            signInAlready: widget.email != null && widget.uid != null,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onRegister() async {
    _unfocusAllNode();
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _comfPassController.text) {
        toastContainer(text: "Password not match", backgroundColor: RED);
        return;
      }

      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: REGISTER_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "firstName": _fNameController.text,
            "lastName": _lNameController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
            "password_confirmation": _comfPassController.text,
            "email_verified":
                widget.email != null && widget.uid != null ? "0" : "1",
          },
        ),
      );
      if (httpResult['ok']) {
        setState(() => _isLoading = true);
        if (widget.email == null && widget.uid == null) {
          toastContainer(
            text: httpResult["data"]["msg"],
            backgroundColor: GREEN,
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
        } else {
          _onLogin();
        }
      } else {
        setState(() => _isLoading = false);
        toastContainer(text: httpResult["data"]["msg"], backgroundColor: RED);
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
      userModel = UserModel.fromJson(httpResult['data']);
      await getAllOtherFiles(state: (String text) {  });
      await continueSignUpOnFirebase(
        firebaseUserId: widget.uid,
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
      if (httpResult["statusCode"] == 200) {
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: RED,
        );
      } else {
        toastContainer2(
          context: context,
          text: httpResult["error"],
          backgroundColor: RED,
        );
      }
    }
  }
}
