import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/spec/colors.dart';

import 'widget/addReportWidget.dart';

class AddReport extends StatefulWidget {
  final String? postId, albumId, radioId, playlistId, bannerId;

  AddReport({
    @required this.albumId,
    @required this.postId,
    @required this.radioId,
    this.playlistId,
    this.bannerId,
  });

  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController(
    text: userModel!.data!.user!.email,
  );
  final _phoneController = new TextEditingController();
  final _reasonController = new TextEditingController();

  bool _isLoading = false;

  FocusNode? _phoneFocusNode,
      _emailFocusNode,
      _reasonFocusNode;
  @override
  void initState() {
    super.initState();
    _phoneFocusNode = new FocusNode();
    _emailFocusNode = new FocusNode();
    _reasonFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneFocusNode!.dispose();
    _emailFocusNode!.dispose();
    _reasonFocusNode!.dispose();
  }

  void _unfocusAllNode() {
    _phoneFocusNode!.unfocus();
    _emailFocusNode!.unfocus();
    _reasonFocusNode!.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Content")),
      body: Stack(
        children: [
          addReportWidget(
            context: context,
            emailController: _emailController,
            emailFocusNode: _emailFocusNode,
            key: _formKey,
            phoneController: _phoneController,
            phoneFocusNode: _phoneFocusNode,
            reasonController: _reasonController,
            reasonFocusNode: _reasonFocusNode,
            onReport: () => _onReport(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onReport() async {
    _unfocusAllNode();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: REPORTCASE_URL,
          method: HTTPMETHOD.POST,
          httpPostBody: {
            "email": _emailController.text,
            "phone": _phoneController.text,
            "postID": widget.postId ?? "",
            "albumID": widget.albumId ?? "",
            "playlistID": widget.playlistId ?? "",
            "bannerID": widget.bannerId ?? "",
            "reason": _reasonController.text,
            "status": "0",
          },
        ),
      );
      if (httpResult['ok']) {
        toastContainer(
          text: httpResult["data"]["msg"],
          backgroundColor: GREEN,
        );
        navigation(context: context, pageName: "homepage");
        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoading = false);
        toastContainer(text: httpResult["data"]["msg"], backgroundColor: RED);
      }
    }
  }
}
