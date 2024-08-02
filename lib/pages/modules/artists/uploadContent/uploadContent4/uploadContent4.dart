import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/spec/colors.dart';

import '../uploadContent5/uploadContent5.dart';
import 'widget/uploadContent4Widget.dart';

final lyricsController = new TextEditingController();

class UploadContent4 extends StatefulWidget {
  final Map<String, dynamic>? meta;

  UploadContent4(this.meta);

  @override
  State<UploadContent4> createState() => _UploadContent4State();
}

class _UploadContent4State extends State<UploadContent4> {
  FocusNode? _lyricsFocusNode;

  @override
  void initState() {
    super.initState();
    _lyricsFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _lyricsFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Content")),
      body: uploadContent4Widget(
        context: context,
        lyricsController: lyricsController,
        lyricsFocusNode: _lyricsFocusNode,
        onAttach: () => _onAttach(),
        onPaste: () => _onPaste(),
        onClearAll: () => _onClearAll(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: button(
          onPressed: () => _onPreview(),
          text: "Preview and Submit",
          color: PRIMARYCOLOR,
          context: context,
        ),
      ),
    );
  }

  void _onPreview() {
    _lyricsFocusNode!.unfocus();
    Map<String, dynamic> meta = {
      ...widget.meta!,
      "lyrics": lyricsController.text,
    };
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadContent5(meta),
      ),
    );
  }

  Future<void> _onAttach() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Uplaod Attachment(s)",
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ["txt"],
    );

    if (result != null) {
      File file = File(result.files[0].path!);
      String data = await file.readAsString(encoding: utf8);
      lyricsController.text = data;
      setState(() {});
    }
  }

  void _onPaste() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        lyricsController.text = "${lyricsController.text} $value";
      });
    });
  }

  void _onClearAll() {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () {
        _lyricsFocusNode!.unfocus();
        lyricsController.clear();
        navigation(context: context, pageName: "back");
      },
      type: CoolAlertType.warning,
      text: "You about to clear all lyrics text",
      confirmBtnText: "Clear",
    );
  }
}
