import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rally/bloc/myPlaylistsBloc.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/congratPage.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/downloadFIle.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/http/others/httpPlaylistCreation.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allGenreModel.dart';
import 'package:rally/models/myPlaylistsModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/selectGenre.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/widget/createPlaylistsWidget.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/widget/previewPlaylistsWidget.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

final _titleController = new TextEditingController();
final _descriptionController = new TextEditingController();
final _genreController = new TextEditingController();
final _permissionController = new TextEditingController();
String _playlistCover = "";
List<String> _contentIdList = [];

// AllGenreData? _allGenreData;
int _permissionIndex = 0;

class CreatePlaylists extends StatefulWidget {
  final PlayerModel? playerModel;
  final MyPlaylistsData? myPlaylistsData;

  CreatePlaylists({
    @required this.playerModel,
    this.myPlaylistsData,
  });

  @override
  State<CreatePlaylists> createState() => _CreatePlaylistsState();
}

class _CreatePlaylistsState extends State<CreatePlaylists> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode? _titleFocusNode, _descriptionFocusNode;

  bool _isLoading = false,
      _isLocalImage = true,
      _showAddPlaylist = true,
      _isPlaylistOnce = true;

  String _loadingMsg = "";
  double? _loadingPercentage;

  int _descriptionLength = 0;
  bool _isDescriptionFull = false;

  List<String> _permissionList = [
    "Public - Anyone can view",
    "Private - Only you can view",
  ];

  String _appBarTitle = "Loading Playlists";
  String? _playlistId;

  Repository repo = new Repository();

  @override
  void initState() {
    super.initState();
    _titleFocusNode = new FocusNode();
    _descriptionFocusNode = new FocusNode();

    if (widget.playerModel != null)
      myPlaylistsBloc.fetch(userModel!.data!.user!.userid, "2");
    else {
      _appBarTitle = "Create New Playlist";
      _onClearAllFields();
    }

    if (widget.myPlaylistsData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onLoadEditData();
      });
    }

    // description length
    _descriptionLength = _descriptionController.text.length;
    _isDescriptionFull = _descriptionLength > 5000;

    _permissionIndex = 0;

    if (widget.playerModel != null) {
      _contentIdList = [
        for (var data in widget.playerModel!.data!) data.id.toString()
      ];
      if (widget.playerModel!.data![0].isCoverLocal!)
        _playlistCover = widget.playerModel!.data![0].cover!;
      else
        _downloadCover(widget.playerModel!.data![0].cover!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode!.dispose();
    _descriptionFocusNode!.dispose();
  }

  Future<void> _onLoadEditData() async {
    setState(() => _isLoading = true);
    _appBarTitle = "Edit Playlist";
    _titleController.text = widget.myPlaylistsData!.title!;
    _descriptionController.text = widget.myPlaylistsData!.description!;
    _genreController.text = widget.myPlaylistsData!.genres!.length > 0
        ? widget.myPlaylistsData!.genres![0]
        : "";
    _permissionIndex = int.parse(widget.myPlaylistsData!.public!);
    _permissionController.text = _permissionList[_permissionIndex];
    _playlistId = widget.myPlaylistsData!.id.toString();
    await _downloadCover(widget.myPlaylistsData!.media!.raw!);
    _contentIdList = [
      for (var content in widget.myPlaylistsData!.content!) content.id!
    ];
    setState(() => _isLoading = false);
  }

  Future<void> _downloadCover(String url) async {
    setState(() => _isLoading = true);
    String fileName = url.substring(url.lastIndexOf("/") + 1);
    String filePath = await getFilePath(fileName);
    await downloadFile(
      url,
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
        _playlistCover = savePath!;
        _isLoading = false;
        _loadingPercentage = null;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle)),
      body: widget.playerModel == null
          ? _mainContent(null)
          : StreamBuilder(
              stream: myPlaylistsBloc.allPlaylists,
              builder: (
                BuildContext context,
                AsyncSnapshot<MyPlaylistsModel> snapshot,
              ) {
                if (snapshot.hasData) {
                  if (snapshot.data!.ok!) {
                    if (snapshot.data!.data!.length > 0)
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _appBarTitle = "Add to Playlist";
                        if (_isPlaylistOnce) {
                          _showAddPlaylist = false;
                          _isPlaylistOnce = false;
                        }
                        setState(() {});
                      });
                    return _mainContent(snapshot.data);
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _appBarTitle = "Create New Playlist";
                      if (_isPlaylistOnce) {
                        _showAddPlaylist = true;
                        _isPlaylistOnce = false;
                      }
                      setState(() {});
                    });
                    return _mainContent(null);
                  }
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _appBarTitle = "Create New Playlist";
                    if (_isPlaylistOnce) {
                      _showAddPlaylist = true;
                      _isPlaylistOnce = false;
                    }
                    setState(() {});
                  });
                  return _mainContent(null);
                }
                return shimmerItem();
              },
            ),
    );
  }

  Widget _mainContent(MyPlaylistsModel? model) {
    return Stack(
      children: [
        !_showAddPlaylist
            ? previewPlaylistsWidget(
                context: context,
                onAddPlaylist: () {
                  setState(() {
                    _showAddPlaylist = true;
                  });
                },
                model: model,
                onPlaylist: (MyPlaylistsData data) =>
                    _onAddContentToPlaylistDialog(data),
                onPopupAction: (String action, MyPlaylistsData data) =>
                    _onPopupAction(action, data),
              )
            : createPlaylistsWidget(
                context: context,
                titleController: _titleController,
                titleFocusNode: _titleFocusNode,
                cover: _playlistCover,
                isLocalImage: _isLocalImage,
                onUploadBannerCover: () => _onUploadBannerCover(),
                descriptionController: _descriptionController,
                descriptionFocusNode: _descriptionFocusNode,
                descriptionLength: _descriptionLength,
                genreController: _genreController,
                isDescriptionFull: _isDescriptionFull,
                key: _formKey,
                onDescriptionTextChange: (String text) =>
                    _onDescriptionTextChange(text),
                onGenre: () => _onGenre(),
                onPermission: () => _onPermission(),
                permissionController: _permissionController,
                onSave: () => _onSavePlaylist(),
                onMyPlaylists: () {
                  setState(() {
                    _showAddPlaylist = false;
                  });
                },
                model: model,
              ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  Future<void> _onPopupAction(String action, MyPlaylistsData data) async {
    if (action == "ed") {
      _loadingMsg = "";
      setState(() => _isLoading = true);
      _titleController.text = data.title!;
      _descriptionController.text = data.description!;
      _genreController.text = data.genres!.length > 0 ? data.genres![0] : "";
      _permissionIndex = int.parse(data.public!);
      _permissionController.text = _permissionList[_permissionIndex];
      _playlistId = data.id.toString();
      await _downloadCover(data.media!.raw!);
      _showAddPlaylist = true;
      setState(() => _isLoading = false);
      _contentIdList = [for (var content in data.content!) content.id!];
    } else if (action == "dl") {
      coolAlertDialog(
        context: context,
        onConfirmBtnTap: () => _onDeletePlaylist(data),
        type: CoolAlertType.warning,
        text:
            "You are about to delete this playlist. Understand that deleting is permanent, and can't be undone",
        confirmBtnText: "Delete Forever",
      );
    }
  }

  Future<void> _onDeletePlaylist(MyPlaylistsData data) async {
    _loadingMsg = "";
    setState(() => _isLoading = true);
    navigation(context: context, pageName: "back");
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETECONTENTPLAYLISTS_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "playlists": json.encode([data.id.toString()]),
          "userid": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      await myPlaylistsBloc.fetch(userModel!.data!.user!.userid, "2");
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

  void _onAddContentToPlaylistDialog(MyPlaylistsData data) {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onAddContentToPlaylist(data),
      type: CoolAlertType.warning,
      text: "You are sure you want to add to this playlist?",
      confirmBtnText: "Add To Playlist",
    );
  }

  Future<void> _onAddContentToPlaylist(MyPlaylistsData data) async {
    _loadingMsg = "";
    setState(() => _isLoading = true);
    navigation(context: context, pageName: "back");
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: ADDCONTENTPLAYLISTS_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "content": json.encode(_contentIdList),
          "id": data.id.toString(),
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      await myPlaylistsBloc.fetch(userModel!.data!.user!.userid, "2");
      await repo.fetchAllPlaylists(true, "", "0");
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

  Future<void> _onSavePlaylist() async {
    _titleFocusNode!.unfocus();
    _descriptionFocusNode!.unfocus();
    if (_playlistCover == "") {
      toastContainer(text: "Upload cover to proceed", backgroundColor: RED);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    _loadingMsg =
        _playlistId == null ? "Creating playlist..." : "Updating playlist...";
    Map<String, dynamic> meta = {
      "title": _titleController.text,
      "description": _descriptionController.text,
      "genre": _genreController.text,
      "content": _contentIdList,
      "permission": _permissionIndex,
      "cover": _playlistCover,
      "playlistId": _playlistId,
    };

    await httpPlaylistCreation(
      meta: meta,
      onFunction: (Map<String, dynamic>? data) async {
        if (data != null && data["ok"]) {
          _onClearAllFields();
          await repo.fetchAllPlaylists(true, "", "0");
          setState(() => _isLoading = false);
          toastContainer(text: data["msg"], backgroundColor: GREEN);
          _onCongratPage(data["msg"]);
        } else {
          setState(() => _isLoading = false);
          toastContainer(text: data!["msg"], backgroundColor: RED);
        }
      },
      onUploadProgress: (int sentBytes, int totalBytes) {},
    );
  }

  void _onClearAllFields() {
    _titleController.clear();
    _descriptionController.clear();
    _genreController.clear();
    _permissionController.clear();
    _playlistCover = "";
    _permissionIndex = 0;
    _contentIdList = [];
  }

  void _onCongratPage(String text) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CongratPage(
            onHome: (context) => navigation(
              context: context,
              pageName: "homepage",
            ),
            widget: Column(
              children: [
                Text("$text", style: h2WhiteBold, textAlign: TextAlign.center),
                SizedBox(height: 40),
                button(
                  onPressed: () => navigation(
                    context: context,
                    pageName: "myplaylists",
                  ),
                  text: "View Playlists",
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

  Future<void> _onPermission() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: BACKGROUND,
            title: Text('Select Permission', style: h6White),
            children: <Widget>[
              for (int x = 0; x < _permissionList.length; ++x) ...[
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      _permissionController.text = _permissionList[x];
                      _permissionIndex = x;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(_permissionList[x], style: h5WhiteBold),
                ),
                Divider(color: BLACK),
              ],
            ],
          );
        });
  }

  Future<void> _onGenre() async {
    AllGenreData? data = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectGenre(),
      ),
    );

    if (data != null) {
      // _allGenreData = data;
      _genreController.text = data.name!;
      setState(() {});
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
        _playlistCover = files[0].absolute.path;
        _isLoading = false;
      });
    } else {
      print("No file uploaded");
    }
  }
}
