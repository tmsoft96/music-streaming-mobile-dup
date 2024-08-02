import 'package:flutter/material.dart';
import 'package:rally/bloc/reasonsBloc.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/auth/googleService.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/deleteCache.dart';
import 'package:rally/config/firebase/firebaseAuth.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/config/services.dart';
import 'package:rally/config/sharePreference.dart';
import 'package:rally/models/reasonsModel.dart';
import 'package:rally/pages/modules/account/deleteAccount/widget/deleteAccountWidget.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/deleteAccountDialog.dart';

class DeleteAccount extends StatefulWidget {
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  FireAuth _firebaseAuth = new FireAuth();
  GoogleService _googleService = new GoogleService();

  List<Map<String, dynamic>> reasonList = [
    {"reason": "I don't need it anymore", "selected": true},
    {"reason": "It is too expensive", "selected": false},
    {"reason": "I'm switching to another ccount", "selected": false},
    {"reason": "Other", "selected": false},
  ];

  int _selectedReasonIndex = 0;
  String? _selectedReason;

  final _reasonController = new TextEditingController();

  FocusNode? _reasonFocusNode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _reasonFocusNode = new FocusNode();
    loadReasonsMapOffline();
    reasonsBloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _reasonFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Account")),
      body: StreamBuilder(
        stream: reasonsBloc.reasons,
        initialData: reasonsMapOffline == null
            ? null
            : ReasonsModel.fromJson(
                json: reasonsMapOffline,
                httpMsg: "Offline Data",
              ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return reasonsMapOffline == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(
                      ReasonsModel.fromJson(
                        json: reasonsMapOffline,
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

  Widget _mainContent(ReasonsModel model) {
    return Stack(
      children: [
        deleteAccountWidget(
          context: context,
          onSelectReason: (int index) => _onSelectReason(model, index),
          onDelete: () => _onDeleteDialog(),
          selectedReasonIndex: _selectedReasonIndex,
          reasonController: _reasonController,
          reasonFocusNode: _reasonFocusNode,
          model: model,
          selectedReason: _selectedReason,
        ),
        if (_isLoading) customLoadingPage(),
      ],
    );
  }

  void _onSelectReason(ReasonsModel model, int index) {
    _reasonFocusNode!.unfocus();
    _selectedReason = model.data![index];
    _selectedReasonIndex = index;
    if (index != model.data!.length - 1)
      _reasonController.text = _selectedReason!;
    else
      _reasonController.clear();
    setState(() {});
  }

  Future<void> _onDeleteDialog() async {
    showDialog(
      context: context,
      builder: (builder) {
        return deleteAccountDialog(
          onCancel: () => Navigator.pop(context),
          onDelete: () => _onDelete(),
        );
      },
    );
  }

  Future<void> _onDelete() async {
    Navigator.pop(context);
    _reasonFocusNode!.unfocus();
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETEUSERACCOUNT_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "reason": _reasonController.text,
        },
      ),
    );
    if (httpResult['ok']) {
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
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: RED);
    }
  }
}
