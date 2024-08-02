import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:rally/utils/videoPlayer/videoPlayer.dart';

import '../uploadContent3/uploadContent3.dart';
import 'widget/uploadContent2Widget.dart';
import 'widget/uploadOption.dart';

String contentCover = "";
List<File> contentFileList = [];
List<String> contentFileName = [];

class UploadContent2 extends StatefulWidget {
  final Map<String, dynamic>? meta;

  UploadContent2(this.meta);

  @override
  State<UploadContent2> createState() => _UploadContent2State();
}

class _UploadContent2State extends State<UploadContent2> {
  final _fileNameController = new TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Content")),
      body: Stack(
        children: [
          uploadContent2Widget(
            onUploadContent: (bool isEdit) {
              widget.meta!["contentType"] == 0
                  ? showModalBottomSheet(
                      context: context,
                      builder: (context) => uploadOption(
                        context: context,
                        onAudioSelection: () =>
                            _onUploadContent(isEdit, FileType.audio),
                        onVideoSelection: () =>
                            _onUploadContent(isEdit, FileType.video),
                        onOtherSelection: () =>
                            _onUploadContent(isEdit, FileType.custom),
                      ),
                    )
                  : _onUploadContent(isEdit, FileType.audio);
            },
            onUploadContentCover: () => _onUploadContentCover(),
            meta: widget.meta,
            context: context,
            contentCover: contentCover,
            contentList: contentFileList,
            onRemoveContent: (int index) => _onRemoveFile(index),
            onContent: (int index) => _onContent(index),
            onEditName: (int index) => _onEditFileName(index),
            contentNameList: contentFileName,
            onPlayAll: () => _onContent(null),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: button(
          onPressed: () => _onContinue(),
          text: "Continue",
          color: PRIMARYCOLOR,
          context: context,
        ),
      ),
    );
  }

  void _onEditFileName(int index) {
    String _extention = contentFileName[index].split(".").last;
    _fileNameController.text = contentFileName[index].split(".").first;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PRIMARYCOLOR1,
        title: Text("Change file title", style: h5WhiteBold),
        content: textFormField(
          hintText: "Enter file name",
          controller: _fileNameController,
          focusNode: null,
          backgroundColor: PRIMARYCOLOR1,
          removeBorder: false,
          borderColor: BLACK,
          showBorderRound: false,
          minLine: 2,
          maxLine: null,
        ),
        actions: [
          button(
            onPressed: () {
              contentFileName[index] =
                  "${_fileNameController.text}.$_extention";
              setState(() {});
              navigation(context: context, pageName: "back");
            },
            text: "Change",
            color: PRIMARYCOLOR,
            context: context,
            useWidth: false,
            height: 40,
          ),
        ],
      ),
    );
  }

  void _onContent(int? index) {
    if (contentFileList.length == 0) {
      toastContainer(text: "Upload content first", backgroundColor: RED);
      return;
    }

    Map<String, dynamic> json;
    if (index != null)
      json = {
        "data": [
          {
            "id": -100,
            "title": widget.meta!["contentType"] == 1
                ? contentFileName[index]
                : titleController.text == ""
                    ? "N/A"
                    : titleController.text,
            "lyrics": "",
            "stageName": "${stageNameController.text}",
            "filepath": contentFileList[index].path,
            "cover": "$contentCover",
            "isCoverLocal": contentCover == "" ? false : true,
            "description": "",
            "isFileLocal": true,
          },
        ],
      };
    else
      json = {
        "data": [
          for (int x = 0; x < contentFileList.length; ++x)
            {
              "id": -100,
              "title": contentFileName[x],
              "lyrics": "",
              "stageName": "${stageNameController.text}",
              "filepath": "file:${contentFileList[x].path}",
              "cover": "$contentCover",
              "isCoverLocal": contentCover == "" ? false : true,
              "description": "",
              "isFileLocal": true,
              "artistId": null,
            },
        ],
      };
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(json);

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

  Future<void> _onUploadContentCover() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Uplaod Cover",
      allowMultiple: false,
      type: FileType.image,
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
        contentCover = files[0].absolute.path;
        _isLoading = false;
      });
    } else {
      print("No file uploaded");
    }
  }

  void _onRemoveFile(int index) {
    setState(() {
      contentFileList.removeAt(index);
      contentFileName.removeAt(index);
    });
  }

  Future<void> _onUploadContent(bool isAdd, FileType type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Uplaod Attachment(s)",
      allowMultiple: widget.meta!["contentType"] == 0 ? false : true,
      type: type,
      allowedExtensions: type == FileType.custom ? ["mp3", "m4a"] : null,
    );

    if (result != null) {
      setState(() => _isLoading = true);
      List<PlatformFile> cacheFiles = result.files;
      List<File> saveFiles = result.paths.map((path) => File(path!)).toList();

      setState(() {
        if (widget.meta!["contentType"] == 0) {
          contentFileList = saveFiles;
          contentFileName.clear();
          contentFileName.addAll(
            cacheFiles.map(
              (PlatformFile e) => e.name,
            ),
          );
        } else {
          if (isAdd) {
            contentFileList.addAll(saveFiles);
            contentFileName.addAll(
              cacheFiles.map(
                (PlatformFile e) => e.name,
              ),
            );
          } else {
            contentFileList = saveFiles;
            contentFileName.clear();
            contentFileName.addAll(
              cacheFiles.map(
                (PlatformFile e) => e.name,
              ),
            );
          }
        }
        _isLoading = false;
      });
    } else {
      print("No file uploaded");
    }
  }

  void _onContinue() {
    if (contentCover == "" && contentFileList.length < 1) {
      toastContainer(
        text: "Complete all content details to proceed",
        backgroundColor: RED,
      );
      return;
    }
    Map<String, dynamic> meta = {
      ...widget.meta!,
      "contentCover": contentCover,
      "contents": contentFileList,
      "contentsFileName": contentFileName,
    };
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadContent3(meta),
      ),
    );
  }
}
