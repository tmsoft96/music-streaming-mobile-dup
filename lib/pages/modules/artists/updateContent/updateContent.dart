import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpFileUploader.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:rally/utils/webBrowser/webBrower.dart';

import '../uploadContent/uploadContent3/uploadContent3.dart';
import 'widget/updateContentWidget.dart';

class UpdateContent extends StatefulWidget {
  final AllMusicData? allMusicData;
  final AllAlbumData? allAlbumData;

  UpdateContent({
    @required this.allMusicData,
    @required this.allAlbumData,
  });

  @override
  State<UpdateContent> createState() => _UpdateContentState();
}

class _UpdateContentState extends State<UpdateContent> {
  String _contentCover = "";
  bool _isLoading = false;

  final _descriptionController = new TextEditingController();
  final _titleController = new TextEditingController();
  final _tagController = new TextEditingController();
  final _stageNameController = new TextEditingController();

  List<String> _tagsList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode? _titleFocusNode,
      _descriptionFocusNode,
      _tagFocusNode,
      _stageNameFocusNode;

  int _tagLength = 0, _descriptionLength = 0;
  bool _isTagFull = false, _isDescriptionFull = false;

  Map<String, dynamic>? meta;

  String _loadingMsg = "";

  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = new FocusNode();
    _descriptionFocusNode = new FocusNode();
    _tagFocusNode = new FocusNode();
    _stageNameFocusNode = new FocusNode();

    // tag length
    for (String tag in _tagsList) _tagLength += tag.length;
    _isTagFull = _tagLength > 5000;

    // description length
    _descriptionLength = _descriptionController.text.length;
    _isDescriptionFull = _descriptionLength > 5000;
    _loadAllData();
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode!.dispose();
    _descriptionFocusNode!.dispose();
    _tagFocusNode!.dispose();
    _stageNameFocusNode!.dispose();
  }

  void _unfocusAllNodes() {
    _titleFocusNode!.unfocus();
    _descriptionFocusNode!.unfocus();
    _tagFocusNode!.unfocus();
    _stageNameFocusNode!.unfocus();
  }

  void _loadAllData() {
    _titleController.text = widget.allMusicData != null
        ? widget.allMusicData!.title!
        : widget.allAlbumData!.name!;
    _descriptionController.text = widget.allMusicData != null
        ? (widget.allMusicData!.description == null
            ? ""
            : widget.allMusicData!.description!)
        : (widget.allAlbumData!.description == null
            ? ""
            : widget.allAlbumData!.description!);
    _tagsList = widget.allMusicData != null
        ? (widget.allMusicData!.tags == null ? [] : widget.allMusicData!.tags!)
            as List<String>
        : (widget.allAlbumData!.tags == null ? [] : widget.allAlbumData!.tags!)
            as List<String>;

    meta = {"contentType": widget.allMusicData != null ? 0 : 1};

    _stageNameController.text = widget.allMusicData != null
        ? widget.allMusicData!.stageName!
        : widget.allAlbumData!.stageName!;

    if (widget.allAlbumData != null) {
      publicationStatusList[0]["selected"] = widget.allAlbumData!.public == "0";
      publicationStatusList[1]["selected"] = widget.allAlbumData!.public == "1";
      publicationStatusSelectedIndex =
          widget.allAlbumData!.public == "0" ? 0 : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Content")),
      body: Stack(
        children: [
          updateContentWidget(
            contentCover: _contentCover,
            context: context,
            onUploadContentCover: () => _onUploadContentCover(),
            allMusicData: widget.allMusicData,
            onContent: () => _onContent(),
            descriptionController: _descriptionController,
            descriptionFocusNode: _descriptionFocusNode,
            tagController: _tagController,
            tagFocusNode: _tagFocusNode,
            titleController: _titleController,
            titleFocusNode: _titleFocusNode,
            onPreview: () => _onUpdate(),
            onTagDelete: (int index) => _onTagDelete(index),
            onTagAdd: () => _onTagAdd(_tagController.text),
            key: _formKey,
            descriptionLength: _descriptionLength,
            onDescriptionTextChange: (String text) => _onDescriptionTextChange(
              text,
            ),
            tagLength: _tagLength,
            tagsList: _tagsList,
            isDescriptionFull: _isDescriptionFull,
            isTagFull: _isTagFull,
            onTagTextChange: (String text) => _onTagAdd(
              text,
              isTextChange: true,
            ),
            allAlbumData: widget.allAlbumData,
            albumPublicationList: publicationStatusList,
            onAlbumPublication: (int index) => _onAlbumPublication(index),
            meta: meta,
            stageNameController: _stageNameController,
            stageNameFocusNode: _stageNameFocusNode,
            onTermsAndCondition: () => _onNavigateToWeb(
              TERMSANDCONDITION_URL,
              "Terms and Condition",
              context,
            ),
          ),
          if (_isLoading)
            customLoadingPage(
              msg: _loadingMsg,
              percent: _loadingPercentage,
            ),
        ],
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

  void _onAlbumPublication(int index) {
    for (var data in publicationStatusList) data["selected"] = false;
    publicationStatusList[index]["selected"] = true;
    publicationStatusSelectedIndex = index;
    setState(() {});
  }

  Future<void> _onUpdate() async {
    setState(() => _isLoading = true);
    if (_contentCover != "") {
      List<String> pathList = [_contentCover];
      await httpFileUploader(
        imageList: pathList,
        endpoint: UPLOADPICTURE_URL,
        onFunction: () => _onSubmitRequest(),
      );
    } else
      _onSubmitRequest();
  }

  Future<void> _onSubmitRequest() async {
    _unfocusAllNodes();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint:
            widget.allMusicData != null ? POSTUPDATE_URL : UPDATEALBUMS_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: widget.allMusicData != null
            ? {
                "post": widget.allMusicData!.id.toString(),
                "userid": userModel!.data!.user!.userid,
                "title": _titleController.text.trimRight(),
                "filepath": widget.allMusicData!.filepath,
                "cover_filepath": _contentCover != ""
                    ? allFileUrl[0]
                    : widget.allMusicData!.cover,
                "stage_name": _stageNameController.text,
                "lyrics": "",
                "tags": json.encode(_tagsList),
                "description": _descriptionController.text.trimRight(),
              }
            : {
                "album": widget.allAlbumData!.id.toString(),
                "userid": userModel!.data!.user!.userid,
                "name": _titleController.text,
                "description": _descriptionController.text,
                "modifyUser": userModel!.data!.user!.userid,
                "tags": json.encode(_tagsList),
                "status": publicationStatusSelectedIndex.toString(),
                "stage_name": _stageNameController.text,
              },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      publicationStatusList[0]["selected"] = true;
      publicationStatusList[1]["selected"] = false;
      publicationStatusSelectedIndex = 0;
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
      navigation(context: context, pageName: "artisthomepage");
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  void _onTagAdd(String text, {bool isTextChange = false}) {
    if (text == "" || text == " ") {
      toastContainer(text: "Enter text", backgroundColor: RED);
      return;
    }
    if (text.contains(";") || !isTextChange) {
      _unfocusAllNodes();
      _tagsList += [text.split(";")[0].trimLeft().trimRight()];
      _tagLength = 0;
      for (String tag in _tagsList) _tagLength += tag.length;
      _isTagFull = _tagLength > 5000;
      _tagController.clear();
      setState(() {});
    }
  }

  void _onTagDelete(int index) {
    _tagsList.removeAt(index);
    _tagLength = 0;
    for (String tag in _tagsList) _tagLength += tag.length;
    _isTagFull = _tagLength > 5000;
    setState(() {});
  }

  void _onDescriptionTextChange(String text) {
    _descriptionLength = text.length;
    _isDescriptionFull = _descriptionLength > 5000;
    setState(() {});
  }

  Future<void> _onUploadContentCover() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Uplaod Attachment(s)",
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["jpg", "jpeg", "png"],
    );
    if (result != null) {
      setState(() => _isLoading = true);
      List<File> files = result.paths.map((path) => File(path!)).toList();

      var decodedImage = await decodeImageFromList(files[0].readAsBytesSync());
      int height = decodedImage.height;
      int width = decodedImage.width;

      if (height > 5000 || width > 5000) {
        setState(() => _isLoading = false);
        coolAlertDialog(
          context: context,
          onConfirmBtnTap: () => navigation(context: context, pageName: "back"),
          type: CoolAlertType.warning,
          text:
              "Your image is $height X $width\px\n\nCover must be below 5000 X 5000px",
          confirmBtnText: "Close",
        );
        return;
      }

      // Directory dir = await getTemporaryDirectory();
      // String targetedPath =
      //     "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      // File? compressResult = await FlutterImageCompress.compressAndGetFile(
      //   files[0].absolute.path,
      //   targetedPath,
      //   quality: 40,
      //   rotate: 0,
      // );

      // print(files[0].lengthSync());
      // print(compressResult!.lengthSync());

      setState(() {
        _contentCover = files[0].absolute.path;
        _isLoading = false;
      });
    } else {
      print("No file uploaded");
    }
  }

  Future<void> _onContent() async {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": widget.allMusicData!.id,
          "title": widget.allMusicData!.title,
          "lyrics": widget.allMusicData!.lyrics,
          "stageName": widget.allMusicData!.stageName,
          "filepath": widget.allMusicData!.filepath,
          "cover": widget.allMusicData!.cover,
          "thumb": widget.allMusicData!.media!.thumb,
          "thumbnail": widget.allMusicData!.media!.thumbnail,
          "isCoverLocal": false,
          "description": widget.allMusicData!.description,
          "isFileLocal": false,
          "artistId": widget.allMusicData!.userid,
        },
      ],
    };
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(json);
    final musicInitialize = MusicInitialize(playerModel: playerModel);
    if (player != null) musicInitialize.dispose();
    musicInitialize.init();
    setState(() => _isLoading = false);
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: false,
      backgroundColor: TRANSPARENT,
      builder: (context) => MusicPlayer(playerModel: playerModel),
    );
  }
}
