import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/bloc/allPodcastBloc.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/congratPage.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/http/others/httpAddBroadcast.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allPodcastModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/spec/theme.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/addRadioWidget.dart';

final _titleController = new TextEditingController();
final _descriptionController = new TextEditingController();
String _broadcastCover = "", _time = "", _date = "";

List<String> _tagsList = [];
List<File> _contentFileList = [];

List<Map<String, dynamic>> _broadcastTypeList = [
  {
    "title": "Pre-recorded Section",
    "selected": true,
  },
  {
    "title": "Live Session",
    "selected": false,
  },
];

int _selectedBroadcastIndex = 0;

class AddRadio extends StatefulWidget {
  final AllRadioData? allRadioData;

  AddRadio({this.allRadioData});

  @override
  State<AddRadio> createState() => _AddRadioState();
}

class _AddRadioState extends State<AddRadio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _tagController = new TextEditingController();

  FocusNode? _titleFocusNode, _descriptionFocusNode, _tagFocusNode;

  bool _isLoading = false,
      _isLocalImage = true,
      _isLocalContent = true,
      _isDescriptionFull = false,
      _isTagFull = false;

  int _descriptionLength = 0, _tagLength = 0;

  String? _timezone;
  String _loadingMsg = "";
  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = new FocusNode();
    _descriptionFocusNode = new FocusNode();
    _tagFocusNode = new FocusNode();

    _loadTimestamp();

    // load data for edit
    if (widget.allRadioData != null) {
      _titleController.text = widget.allRadioData!.title!;
      _descriptionController.text = widget.allRadioData!.description!;
      _broadcastCover = widget.allRadioData!.cover!;
      _isLocalImage = false;
      _date = widget.allRadioData!.startDate!.split(" ").first;
      _time = widget.allRadioData!.startDate!.split(" ").last;
      _tagsList = widget.allRadioData!.tags!;
      String status = widget.allRadioData!.public!;
      if (status == "0") {
        _broadcastTypeList[0]["selected"] = true;
        _broadcastTypeList[1]["selected"] = false;
        _contentFileList = [File(widget.allRadioData!.filepath!)];
        _isLocalContent = false;
      } else {
        _broadcastTypeList[0]["selected"] = false;
        _broadcastTypeList[0]["selected"] = true;
      }
      _timezone = widget.allRadioData!.timezone;
    }

    // tag length
    for (String tag in _tagsList) _tagLength += tag.length;
    _isTagFull = _tagLength > 5000;

    // description length
    _descriptionLength = _descriptionController.text.length;
    _isDescriptionFull = _descriptionLength > 5000;
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode!.dispose();
    _descriptionFocusNode!.dispose();
    _tagFocusNode!.dispose();
  }

  void _unfocusAllNodes() {
    _titleFocusNode!.unfocus();
    _descriptionFocusNode!.unfocus();
    _tagFocusNode!.unfocus();
  }

  void _loadTimestamp() {
    String timeZoneOffset = DateTime.now().timeZoneOffset.toString();
    String timeZone =
        timeZoneOffset.substring(0, timeZoneOffset.lastIndexOf(":"));
    print(timeZone);
    String formatTimeZone = "";
    if (timeZone.startsWith("-"))
      formatTimeZone = "-0" + timeZone.substring(1, timeZone.length);
    else if (timeZone.startsWith("+"))
      formatTimeZone = "+0" + timeZone.substring(1, timeZone.length);
    else
      formatTimeZone = "+0" + timeZone.substring(0, timeZone.length);

    _timezone = formatTimeZone;
  }

  void _clearData() {
    _broadcastCover = "";
    _time = "";
    _date = "";
    _tagsList = [];
    _descriptionController.clear();
    _titleController.clear();
    _contentFileList = [];
    _broadcastTypeList[0]["selected"] = true;
    _broadcastTypeList[1]["selected"] = false;
    _selectedBroadcastIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.allRadioData != null) _clearData();
        navigation(context: context, pageName: "back");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (widget.allRadioData != null) _clearData();
              navigation(context: context, pageName: "back");
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Add Radio"),
        ),
        body: Stack(
          children: [
            addRadioWidget(
              broadcastCover: _broadcastCover,
              context: context,
              isLocalImage: _isLocalImage,
              onUploadBroadcastCover: () => _onUploadBannerCover(),
              titleController: _titleController,
              titleFocusNode: _titleFocusNode,
              descriptionController: _descriptionController,
              descriptionFocusNode: _descriptionFocusNode,
              descriptionLength: _descriptionLength,
              isDescriptionFull: _isDescriptionFull,
              key: _formKey,
              onDescriptionTextChange: (String text) =>
                  _onDescriptionTextChange(
                text,
              ),
              onTime: () => _onTime(),
              time: _time,
              date: _date,
              onDate: () => _onDate(),
              broadcastTypeList: _broadcastTypeList,
              onBroadcastType: (int index) => _onBroadcastType(index),
              onSubmit: () => _onSubmitConfirmation(),
              onTagDelete: (int index) => _onTagDelete(index),
              onTagAdd: () => _onTagAdd(_tagController.text),
              tagController: _tagController,
              tagFocusNode: _tagFocusNode,
              tagLength: _tagLength,
              tagsList: _tagsList,
              isTagFull: _isTagFull,
              onTagTextChange: (String text) => _onTagAdd(
                text,
                isTextChange: true,
              ),
              contentList: _contentFileList,
              onRemoveContent: (int index) => _onRemoveFile(index),
              onContent: (int index) => _onContent(index),
              onUploadContent: (bool isEdit) => _onUploadContent(isEdit),
              selectedBroadcastIndex: _selectedBroadcastIndex,
              isLocalContent: _isLocalContent,
              onPlayPreRecorded: () => _onPlayPreRecorded(),
            ),
            if (_isLoading)
              customLoadingPage(
                msg: _loadingMsg,
                percent: _loadingPercentage,
              ),
          ],
        ),
      ),
    );
  }

  void _onSubmitConfirmation() {
    _unfocusAllNodes();
    if (_broadcastCover == "") {
      toastContainer(
        text: "Upload broadcast cover to proceed",
        backgroundColor: RED,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      toastContainer(
        text: "The title and description must not be left blank.",
        backgroundColor: RED,
      );
      return;
    }

    if (_time == "" && _date == "") {
      toastContainer(
        text: "The time and date must be set before you proceed.",
        backgroundColor: RED,
      );
      return;
    }

    if (_selectedBroadcastIndex == 0 && _contentFileList.length == 0) {
      toastContainer(
        text: "Upload a pre-recorded content to proceed",
        backgroundColor: RED,
      );
      return;
    }

    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onSubmit(),
      type: CoolAlertType.warning,
      text:
          "You are about to post an upcoming ${_selectedBroadcastIndex == 0 ? 'pre-recorded' : 'live'} broadcast, which will be publicly available on $_date, $_time",
      confirmBtnText: "Submit",
    );
  }

  Future<void> _onSubmit() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> meta = {
      "title": _titleController.text,
      "cover": _broadcastCover,
      "dateTime":
          widget.allRadioData == null ? "$_date $_time:00" : "$_date $_time",
      "status": _selectedBroadcastIndex.toString(),
      "tags": _tagsList,
      "description": _descriptionController.text,
      "contents": _contentFileList,
      "isUpdate": widget.allRadioData != null,
      "isLocalImage": _isLocalImage,
      "isLocalContent": _isLocalContent,
      "editContentPath":
          _selectedBroadcastIndex == 0 ? _contentFileList[0].path : "",
      "postId": widget.allRadioData == null ? "" : widget.allRadioData!.id!,
      "timezone": _timezone,
    };
    await httpAddBroadcast(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) {
        setState(() => _isLoading = false);
        if (data != null && data["ok"]) {
          _clearData();
          _onCongratPage(data["msg"]);
        } else {
          print(data);
          toastContainer(text: data!["msg"], backgroundColor: RED);
        }
      },
    );
  }

  void _onCongratPage(String text) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CongratPage(
            onHome: (context) => navigation(
              context: context,
              pageName: "adminhomepage",
            ),
            widget: Column(
              children: [
                Text("$text", style: h2WhiteBold, textAlign: TextAlign.center),
                SizedBox(height: 40),
                button(
                  onPressed: () => navigation(
                    context: context,
                    pageName: "adminradio",
                  ),
                  text: "View all broadcast",
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

  void _onRemoveFile(int index) {
    setState(() {
      _contentFileList.removeAt(index);
    });
  }

  Future<void> _onUploadContent(bool isAdd) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Uplaod Pre Recorded Broadcast",
      allowMultiple: false,
      type: FileType.audio,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        _contentFileList = files;
        _isLocalContent = true;
      });
    } else {
      print("No file uploaded");
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

  void _onBroadcastType(int index) {
    for (var data in _broadcastTypeList) data["selected"] = false;
    _broadcastTypeList[index]["selected"] = true;
    _selectedBroadcastIndex = index;
    setState(() {});
  }

  Future<void> _onDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: datePickerTheme(),
          child: child!,
        );
      },
    );
    if (selected != null)
      setState(() {
        _date = selected.toIso8601String().split("T")[0];
      });
  }

  Future<void> _onTime() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        _time = result.format(context);
      });
    }
  }

  void _onDescriptionTextChange(String text) {
    _descriptionLength = text.length;
    _isDescriptionFull = _descriptionLength > 5000;
    setState(() {});
  }

  Future<void> _onUploadBannerCover() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Uplaod Cover",
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() => _isLoading = true);
      List<File> files = result.paths.map((path) => File(path!)).toList();

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
        _broadcastCover =  files[0].absolute.path;
        _isLoading = false;
      });
    } else {
      print("No file uploaded");
    }
  }

  void _onContent(int index) {
    if (_contentFileList.length == 0) {
      toastContainer(text: "Upload content first", backgroundColor: RED);
      return;
    }

    Map<String, dynamic> json = {
      "data": [
        {
          "id": -100,
          "title": _titleController.text,
          "lyrics": "",
          "stageName": "",
          "filepath": _contentFileList[index].path,
          "cover": "$_broadcastCover",
          "isCoverLocal": _broadcastCover == "" ? false : true,
          "description": "",
          "isFileLocal": true,
          "artistId": null,
        },
      ],
    };
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(json);
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

  Future<void> _onPlayPreRecorded() async {
    setState(() => _isLoading = true);
    String localPath = "";

    // counting streams
    httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: STREAMPODCAST_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "post_id": widget.allRadioData!.id!.toString(),
        },
      ),
      showToastMsg: false,
    );
    allPodcastBloc.fetch();

    String fileUrl = widget.allRadioData!.filepath!;

    String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
    String filePath = await getFilePath(fileName);

    await downloadFile(
      fileUrl,
      filePath: filePath,
      onProgress: (int rec, int total, String percentCompletedText,
          double percentCompleteValue) {
        print("$rec $total");
        setState(() {
          _loadingMsg = percentCompletedText;
          _loadingPercentage = percentCompleteValue;
        });
      },
      onDownloadComplete: (String? savePath) async {
        setState(() => _isLoading = false);
        localPath = savePath!;
      },
    );
    Map<String, dynamic> json = {
      "data": [
        {
          "id": widget.allRadioData!.id,
          "title": _titleController.text,
          "lyrics": widget.allRadioData!.lyrics,
          "stageName": widget.allRadioData!.stageName,
          "filepath": localPath,
          "cover": _broadcastCover,
          "isCoverLocal": _isLocalImage,
          "description": _descriptionController.text,
          "isFileLocal": true,
          "artistId": null,
        },
      ],
    };
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(json);
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
