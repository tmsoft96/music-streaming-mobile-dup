import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/congratPage.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/others/httpArtistAlbumCreating.dart';
import 'package:rally/config/http/others/httpArtistSingleContentUploader.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent4/uploadContent4.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:rally/utils/videoPlayer/videoPlayer.dart';
import 'package:rally/utils/webBrowser/webBrower.dart';

import '../uploadContent1/uploadContent1.dart';
import '../uploadContent2/uploadContent2.dart';
import '../uploadContent3/uploadContent3.dart';
import 'widget/uploadContent5Widget.dart';

class UploadContent5 extends StatefulWidget {
  final Map<String, dynamic>? meta;

  UploadContent5(this.meta);

  @override
  State<UploadContent5> createState() => _UploadContent5State();
}

class _UploadContent5State extends State<UploadContent5> {
  bool _isLoading = false;
  String _loadingMsg = "";
  String _errorMsg = "";
  double? _loadingPercentage;

  void Function()? onCancelUpload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview")),
      body: Stack(
        children: [
          uploadContent5Widget(
              context: context,
              onSubmit: () => widget.meta!["contentType"] == 1
                  ? _onCreateAlbum()
                  : _onSubmitSingle(),
              onTermsAndCondition: () => _onNavigateToWeb(
                    TERMSANDCONDITION_URL,
                    "Terms and Condition",
                    context,
                  ),
              meta: widget.meta,
              onContent: (String content) => _onContent(content),
              errorMsg: _errorMsg,
              onSeeMore: () => _onSeeMore()),
          if (_isLoading)
            customLoadingPage(
              msg: _loadingMsg,
              percent: _loadingPercentage,
              onClose: onCancelUpload,
            ),
        ],
      ),
    );
  }

  void _onSeeMore() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          color: BACKGROUND,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lyrics", style: h5WhiteBold),
                SizedBox(height: 10),
                Text("${widget.meta!["lyrics"]}", style: h6White),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onNavigateToWeb(String uri, String pageTitle, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebBrowser(
          previousPage: 'back',
          title: pageTitle,
          url: uri,
        ),
      ),
    );
  }

  Future<File> _duplicateFile(File file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    String filename =
        "${DateTime.now().millisecondsSinceEpoch}.${widget.meta!["contentsFileName"][0].toString().split('.').last}";
    File newFile = File("${appStorage.path}/$filename");
    return await File(file.path).copy(newFile.path);
  }

  Future<File> _duplicateCover(File file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    String filename =
        "${DateTime.now().millisecondsSinceEpoch}.${widget.meta!["cover"].toString().split('.').last}";
    File newFile = File("${appStorage.path}/$filename");
    return await File(file.path).copy(newFile.path);
  }

  File? _newFile, _newCover;
  Future<void> _onSubmitSingle() async {
    setState(() => _isLoading = true);
    _loadingMsg = "Uploading file...";

    bool isExit = _newFile != null ? await _newFile!.exists() : false;
    if (_newFile == null || !isExit) {
      _loadingMsg = "Copying file...";
      setState(() {});
      _newFile = await _duplicateFile(widget.meta!["contents"][0]);
      _loadingMsg = "Copying cover...";
      setState(() {});
      _newCover = await _duplicateCover(widget.meta!["cover"]);
    }

    Map<String, dynamic>? meta = widget.meta!;
    meta["contents"][0] = _newFile!;
    meta["cover"] = _newCover!.path;

    await httpArtistSingleContentUploader(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) async {
        setState(() => _isLoading = false);
        if (data != null && data["ok"]) {
          selectedContent = 0;
          contentCover = "";
          contentFileList = [];
          descriptionController.clear();
          titleController.clear();
          stageNameController.clear();
          tagsList = [];
          lyricsController.clear();
          await _newFile!.delete();
          _onCongratPage(data["msg"]);
        } else {
          _errorMsg = "${data!['error']}\n\n${data['value']}";
          setState(() => _isLoading = false);
          // toastContainer(text: "Error occured...", backgroundColor: RED);
          _errorAlert();
        }
      },
      onUploadProgress: (int sentBytes, int totalBytes) {
        print("$sentBytes/$totalBytes");
        _loadingPercentage = sentBytes / totalBytes * 100;
        _loadingMsg = _loadingPercentage!.toStringAsFixed(0) + "%";
        setState(() {});
      },
    );
  }

  void _errorAlert() {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onSubmitSingle(),
      type: CoolAlertType.error,
      text:
          "Upload failed, please try again. \n\nIf error continues:\n1. Change file location and upload again\n2. Rename file and upload again\n3. If all two steps failed then login on to the web to upload file",
      confirmBtnText: "Try Again",
    );
  }

  // 1. Create album
  String? _albumId;
  Future<void> _onCreateAlbum() async {
    setState(() => _isLoading = true);
    _loadingMsg = "Copying cover...";
    _newCover = await _duplicateCover(widget.meta!["cover"]);
    print(widget.meta);
    Map<String, dynamic>? meta = widget.meta!;
    meta["cover"] = _newCover!.path;
    _loadingMsg = "Creating album...";
    setState(() {});
    await httpArtistAlbumCreating(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) {
        print("data $data");
        if (data != null && data["ok"]) {
          _albumId = data["albumId"].toString();
          _onUploadAlbumFile();
        } else {
          setState(() => _isLoading = false);
          toastContainer(text: data!["msg"], backgroundColor: RED);
        }
      },
    );
  }

  // 2. upload all file one by one
  int _submitedFile = 0;
  // List<String> _fileIdList = [];
  Future<void> _onUploadAlbumFile() async {
    _loadingPercentage = null;
    setState(() => _isLoading = true);
    _loadingMsg =
        "Uploading file (${_submitedFile + 1}  / ${widget.meta!["contents"].length})...";

    bool isExit = _newFile != null ? await _newFile!.exists() : false;
    if (_newFile == null || !isExit)
      _newFile = await _duplicateFile(widget.meta!["contents"][_submitedFile]);

    Map<String, dynamic> meta = {
      "artistId": widget.meta!["artistId"],
      "title": widget.meta!["contentsFileName"][_submitedFile],
      "tags": widget.meta!["tags"],
      "genreId": widget.meta!["genreId"],
      "contents": [_newFile],
      "description": widget.meta!["description"],
      "contentCover": _newCover!.path,
      "publicationStatusIndex":
          widget.meta!["publicationStatusIndex"].toString(),
      "stageName": widget.meta!["stageName"],
      "albumId": _albumId,
    };
    print(meta);
    await httpArtistSingleContentUploader(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) async {
        if (data != null && data["ok"]) {
          if (_submitedFile == widget.meta!["contents"].length - 1) {
            // _fileIdList += [data["id"].toString()];
            // _onAttachAlbumFiles();
            selectedContent = 0;
            contentCover = "";
            contentFileList = [];
            descriptionController.clear();
            titleController.clear();
            stageNameController.clear();
            tagsList = [];
            publicationStatusList[0]["selected"] = true;
            publicationStatusList[1]["selected"] = false;
            publicationStatusSelectedIndex = 0;
            await _newFile!.delete();
            setState(() => _isLoading = false);
            toastContainer(text: data["msg"], backgroundColor: GREEN);
            _onCongratPage(data["msg"]);
          } else {
            // _fileIdList += [data["id"].toString()];
            ++_submitedFile;
            _onUploadAlbumFile();
          }
        } else {
          _errorMsg = "${data!['error']}\n\n${data['value']}";
          setState(() => _isLoading = false);
          toastContainer(
            text:
                "file ${_submitedFile + 1}  / ${widget.meta!["contents"].length} unable to be uploaded",
            backgroundColor: RED,
          );
        }
      },
      onUploadProgress: (int sentBytes, int totalBytes) {
        _loadingPercentage = sentBytes / totalBytes * 100;
        _loadingMsg = _loadingPercentage!.toStringAsFixed(0) + "%";
        setState(() {});
      },
    );
  }

  void _onCongratPage(String text) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CongratPage(
            onHome: (context) => navigation(
              context: context,
              pageName:
                  widget.meta!["artistId"] == userModel!.data!.user!.userid
                      ? "artisthomepage"
                      : "adminhomepage",
            ),
            widget: Column(
              children: [
                Text("$text", style: h2WhiteBold, textAlign: TextAlign.center),
                SizedBox(height: 40),
                button(
                  onPressed: () => navigation(
                    context: context,
                    pageName: "allartistcontent",
                  ),
                  text: "View all Contents",
                  color: PRIMARYCOLOR,
                  context: context,
                )
              ],
            ),
            fillButtonColor: false,
          ),
        ),
        (Route<dynamic> route) => false);
  }

  void _onContent(String content) {
    Map<String, dynamic> json = {
      "data": [
        for (int x = 0; x < widget.meta!["contents"].length; ++x)
          {
            "id": -100,
            "title": widget.meta!["contentType"] == 1
                ? widget.meta!["contentsFileName"][x]
                : widget.meta!["title"],
            "lyrics": "",
            "stageName": widget.meta!["stageName"],
            "filepath": 'file:${widget.meta!["contents"][x].path}',
            "cover": widget.meta!["contentCover"],
            "isCoverLocal": true,
            "description": widget.meta!["description"],
            "isFileLocal": true,
          },
      ],
    };
    onHideOverlay();
    PlayerModel playerModel = new PlayerModel.fromJson(json);

    if (playerModel.data![0].filepath!.split("/").last.contains("mp4"))
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoMusicPlayer(playerModel),
        ),
      );
    else {
      final musicInitialize = MusicInitialize(playerModel: playerModel);
      if (player != null) musicInitialize.dispose();
      musicInitialize.init();
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: false,
        backgroundColor: TRANSPARENT,
        builder: (context) => MusicPlayer(playerModel: playerModel),
      );
    }
  }
}
