import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rally/components/congratPage.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'widget/adminEnrollArtistWidget.dart';

class AdminEnrollArtist extends StatefulWidget {
  final AllArtistData? allArtistData;

  AdminEnrollArtist(this.allArtistData);

  @override
  State<AdminEnrollArtist> createState() => _AdminEnrollArtistState();
}

class _AdminEnrollArtistState extends State<AdminEnrollArtist> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enroll Artist")),
      body: Stack(
        children: [
          adminEnrollArtistWidget(
            context: context,
            onDecline: () => _onEnrollOrDecline(2),
            onEnroll: () => _onEnrollOrDecline(0),
            allArtistData: widget.allArtistData,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onEnrollOrDecline(int status) async {
    setState(() => _isLoading = true);

    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: VERIFYARTISTS_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "status": status.toString(),
          "artists": json.encode([widget.allArtistData!.userid]),
          "modifyuser": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
      _onCongratPage(httpResult["data"]["msg"]);
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  void _onCongratPage(String text) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CongratPage(
            onHome: (context) => navigation(
              context: context,
              pageName: "adminhomepage",
            ),
            widget: Text(text, style: h4WhiteBold),
            fillButtonColor: true,
          ),
        ),
        (Route<dynamic> route) => false);
  }
}
