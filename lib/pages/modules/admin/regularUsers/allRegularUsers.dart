import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:rally/bloc/allRegularUserBloc.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allRegularUserModel.dart';
import 'package:rally/pages/authentication/resetPassword/resetPassword.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'widget/allRegularUsersWidget.dart';

class AllRegularUsers extends StatefulWidget {
  const AllRegularUsers({Key? key}) : super(key: key);

  @override
  State<AllRegularUsers> createState() => _AllRegularUsersState();
}

class _AllRegularUsersState extends State<AllRegularUsers> {
  FocusNode? _searchFocusNode;
  String _searchText = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = new FocusNode();
    loadAllRegularUserMapOffline();
    allRegularUserBloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Regular Users")),
      body: StreamBuilder(
        stream: allRegularUserBloc.allRegularUser,
        initialData: allRegularUserMapOffline == null
            ? null
            : AllRegularUserModel.fromJson(
                json: allRegularUserMapOffline,
                httpMsg: "Offline Data",
              ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allRegularUserMapOffline == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(
                      AllRegularUserModel.fromJson(
                        json: allRegularUserMapOffline,
                        httpMsg: "Offline Data",
                      ),
                    );
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem();
        },
      ),
    );
  }

  Widget _mainContent(AllRegularUserModel model) {
    return Stack(
      children: [
        allRegularUsersWidget(
          onSearch: (String text) {
            setState(() {
              _searchText = text;
            });
          },
          searchFocusNode: _searchFocusNode,
          onUser: (Data data) => _onUser(data),
          context: context,
          model: model,
          searchText: _searchText,
        ),
        if (_isLoading) customLoadingPage(),
      ],
    );
  }

  void _onUser(Data data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // title: const Text('Select gender'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResetPassword(userId: data.userid),
                    ),
                  );
                },
                child: Text('Reset Password', style: h5BlackBold),
              ),
              Divider(),
              SimpleDialogOption(
                onPressed: () {
                  coolAlertDialog(
                    context: context,
                    onConfirmBtnTap: () => _onDisableAccount(data),
                    type: CoolAlertType.warning,
                    text: "You are sure you want to diable account",
                    confirmBtnText: "Delete Forever",
                  );
                },
                child: Text('Disable Account', style: h5BlackBold),
              ),
            ],
          );
        });
  }

  Future<void> _onDisableAccount(Data data) async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETERESTOREARTIST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "status": 0,
          "artists": json.encode([data.userid]),
          "modifyuser": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
      navigation(context: context, pageName: "adminhomepage");
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }
}
