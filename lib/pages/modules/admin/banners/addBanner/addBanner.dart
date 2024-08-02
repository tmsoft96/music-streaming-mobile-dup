import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/congratPage.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/http/others/httpCreateBanner.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/pages/modules/admin/banners/addBanner/selectContent.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

import 'widget/addBannerWidget.dart';

final _titleController = new TextEditingController();
String _bannerCover = "";
List<AllMusicData> _contentList = [];

class AddBanner extends StatefulWidget {
  final AllBannersData? allBannersData;

  AddBanner({this.allBannersData});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  FocusNode? _titleFocusNode;

  bool _isLoading = false, _isLocalImage = true;

  String _loadingMsg = "";
  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = new FocusNode();

    if (widget.allBannersData != null) _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode!.dispose();
  }

  void _loadData() {
    _titleController.text = widget.allBannersData!.title!;
    _bannerCover = widget.allBannersData!.cover!;
    _contentList.clear();
    _isLocalImage = false;
    for (var data in widget.allBannersData!.files!) {
      Map<String, dynamic> json = {
        "id": int.parse(data.id.toString()),
        "title": data.title,
        "cover": data.cover,
        "stage_name": data.stageName,
        "filepath": data.filepath,
      };
      _contentList.add(AllMusicData.fromJson(json));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Banner")),
      body: Stack(
        children: [
          addBannerWidget(
            context: context,
            bannerCover: _bannerCover,
            onUploadBannerCover: () => _onUploadBannerCover(),
            titleController: _titleController,
            titleFocusNode: _titleFocusNode,
            contentList: _contentList,
            onContent: (int index) => _onContent(index),
            onRemoveContent: (int index) => _onRemoveContent(index),
            onUploadContent: (bool isEdit) => _onUploadContent(isEdit),
            onPostBanner: () => _onPostBannerConfirmDialog(),
            isLocalImage: _isLocalImage,
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

  void _onPostBannerConfirmDialog() {
    _titleFocusNode!.unfocus();

    if (_titleController.text == "") {
      toastContainer(text: "Enter title to proceed", backgroundColor: RED);
      return;
    }

    if (_bannerCover == "") {
      toastContainer(text: "Upload banner cover image", backgroundColor: RED);
      return;
    }

    if (_contentList.length == 0) {
      toastContainer(text: "Attach content", backgroundColor: RED);
      return;
    }

    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () =>
          _isLocalImage ? _onPostBanner() : _onDownloadCover(),
      type: CoolAlertType.warning,
      text: "Are you sure you want to post a banner?",
      confirmBtnText: "Post Banner",
    );
  }

  Future<void> _onDownloadCover() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    await downloadFile(
      _bannerCover,
      onProgress: (int rec, int total, String percentCompletedText,
          double percentCompleteValue) {
        print("$rec $total");
        _loadingMsg = percentCompletedText;
        _loadingPercentage = percentCompleteValue;
      },
      onDownloadComplete: (String? savePath) async {
        _bannerCover = savePath!;
        _onPostBanner();
      },
    );
  }

  Future<void> _onPostBanner() async {
    if (_isLocalImage) {
      navigation(context: context, pageName: "back");
      setState(() => _isLoading = true);
    }
    List<String> postIdList = [
      for (var data in _contentList) data.id.toString()
    ];
    Map<String, dynamic> meta = {
      "posts": json.encode(postIdList),
      "title": _titleController.text,
      "cover": _bannerCover,
      "bannerId":
          widget.allBannersData != null ? widget.allBannersData!.id : null
    };

    await httpCreateBanner(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) {
        setState(() => _isLoading = false);
        if (data != null && data["ok"]) {
          _titleController.clear();
          _bannerCover = "";
          _contentList = [];
          _onCongratPage(data["msg"]);
        } else {
          setState(() => _isLoading = false);
          toastContainer(text: data!["msg"] ?? "Error occured...", backgroundColor: RED);
        }
      },
    );
  }

  void _onCongratPage(String text) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CongratPage(
            onHome: (context) =>
                navigation(context: context, pageName: "adminhomepage"),
            widget: Column(
              children: [
                Text("$text", style: h2WhiteBold, textAlign: TextAlign.center),
                SizedBox(height: 40),
                button(
                  onPressed: () => navigation(
                    context: context,
                    pageName: "allbanners",
                  ),
                  text: "View all banners",
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

  void _onRemoveContent(int index) {
    _contentList.removeAt(index);
    setState(() {});
  }

  void _onContent(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allAlbumData: null,
          allMusicData: _contentList[index],
        ),
      ),
    );
  }

  Future<void> _onUploadContent(bool isEdit) async {
    AllMusicData? data = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectContent(),
      ),
    );

    if (data != null) {
      _contentList.add(data);
      _isLocalImage = true;
      setState(() {});
    }
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
        _bannerCover =  files[0].absolute.path;
        _isLoading = false;
      });
    } else {
      print("No file uploaded");
    }
  }
}
