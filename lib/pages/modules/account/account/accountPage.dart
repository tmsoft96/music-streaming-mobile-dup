import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/auth/googleService.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/deleteCache.dart';
import 'package:rally/config/firebase/firebaseAuth.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/http/others/httpUpdateAvatar.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/config/sharePreference.dart';
import 'package:rally/pages/modules/admin/completeArtistEnrollment/completeArtistEnrollment.dart';
import 'package:rally/providers/getUserDetailsProvider.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/captureImage/captureImage.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/accountWidget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoading = false;
  FireAuth _firebaseAuth = new FireAuth();
  GoogleService _googleService = new GoogleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: Stack(
        children: [
          accountWidget(
            context: context,
            onUpload: () => userModel!.data!.user!.role!.toLowerCase() ==
                    userTypeList[0]
                ? _onUploadProfilePicture()
                : userModel!.data!.user!.role!.toLowerCase() == userTypeList[1]
                    ? _editArtistProfile()
                    : toastContainer(
                        text: "Admin can't edit profile contact Back Office",
                        backgroundColor: RED,
                      ),
            onLogout: () => _onLogout(),
            onResetPassword: () => navigation(
              context: context,
              pageName: "resetPassword",
            ),
            onDeleteAccount: () => navigation(
              context: context,
              pageName: "deleteaccount",
            ),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  void _editArtistProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CompleteArtistEnrollment(isEdit: true),
      ),
    );
  }

  Future<void> _onUploadProfilePicture() async {
    File imagePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageCapture(),
      ),
    );
    // ignore: unnecessary_null_comparison
    if (imagePath != null) {
      setState(() => _isLoading = true);
      await httpUpdateAvatar(
        avatar: imagePath,
        onFunction: (Map<String, dynamic>? data) async {
          if (data != null && data["ok"]) {
            GetUserDetailsProvider provider = GetUserDetailsProvider();
            userModel = await provider.fetch(
              token: userModel!.data!.token,
              userId: userModel!.data!.user!.userid,
            );
            setState(() => _isLoading = false);
            toastContainer(text: data["msg"], backgroundColor: GREEN);
            navigation(context: context, pageName: "homepage");
          } else {
            toastContainer(text: data!["msg"] ?? "Error occured...", backgroundColor: RED);
          }
        },
      );
    }
  }

  Future<void> _onLogout() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: LOGOUT_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {},
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      onHideOverlay();
      saveBoolShare(key: "auth", data: false);
      await deleteCache();
      await _googleService.googleSignOut();
      await _firebaseAuth.signOut();
      setState(() => _isLoading = false);
      toastContainer(
        text: httpResult["data"]['msg'],
        backgroundColor: GREEN,
      );
      navigation(context: context, pageName: "onboardingpage");
    } else {
      onHideOverlay();
      setState(() => _isLoading = false);
      // toastContainer(text: httpResult["data"]["msg"], backgroundColor: RED);
      saveBoolShare(key: "auth", data: false);
      await deleteCache();
      await _googleService.googleSignOut();
      await _firebaseAuth.signOut();
      navigation(context: context, pageName: "onboardingpage");
    }
  }
}
