import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/bannersModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:rally/utils/videoPlayer/videoPlayer.dart';

import '../admin/banners/addBanner/addBanner.dart';
import 'widget/bannerDetailsWidget.dart';
import '../../../components/generalPopup.dart';

class BannerDetails extends StatefulWidget {
  final AllBannersData? allBannersData;
  final bool? fromAdmin;

  BannerDetails({
    @required this.allBannersData,
    this.fromAdmin = false,
  });

  @override
  State<BannerDetails> createState() => _BannerDetailsState();
}

class _BannerDetailsState extends State<BannerDetails> {
  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("${widget.allBannersData!.title}"),
        actions: [
          if (widget.fromAdmin!) ...[
            IconButton(
              onPressed: () => _onDeleteDialog(),
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () => _onEdit(),
              icon: Icon(Icons.edit),
            ),
          ],
          IconButton(
            onPressed: () => _onMorePopUp(0, widget.allBannersData!),
            icon: Icon(Icons.share),
          ),
          generalPopup(
            onAction: (dynamic action) => _onMorePopUp(
              action,
              widget.allBannersData!,
            ),
            showFavoite: false,
            contentId: widget.allBannersData!.id.toString(),
            contentType: "banner",
          ),
        ],
      ),
      body: Stack(
        children: [
          bannerDetailsWidget(
            context: context,
            data: widget.allBannersData,
            onTrack: (Files file) => _onTrack(file),
            onPlayAll: () => _onPlayAll(),
            onDownloadAll: () => _onMorePopupDownload(widget.allBannersData!),
            onTrackMore: (dynamic action, Files file) =>
                _onTrackMore(action, file),
            onDownloadTrack: (Files file) => _onDownloadTrack(file),
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

  void _onDownloadTrack(Files data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "single${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": data.stageName,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": null,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.cover,
          "thumbnail": data.media!.thumbnail,
          "isCoverLocal": false,
          "description": data.description,
          "artistId": data.userid,
          "downloaded": false,
          "localFile": null,
          "isDownloading": true,
        },
      ],
    };

    contentDownload(meta);
  }

  Future<void> _onMorePopUp(dynamic action, AllBannersData data) async {
    switch (action) {
      case 0:
        setState(() => _isLoading = true);
        String text = "${data.title!}";
        String imageUrl = data.media!.thumbnail!;

        String generatedLink = await _firebaseDynamicLink.createDynamicLink(
          albumId: null,
          albumUrlHash: null,
          singleMusicId: null,
          playlistid: null,
          bannerId: data.id.toString(),
          imageUrl: imageUrl,
          title: text,
        );
        print(generatedLink);
        setState(() => _isLoading = false);
        shareContent(text: generatedLink);
        break;
      case 1:
        Map<String, dynamic> json = {
          "data": [
            for (var content in data.files!)
              {
                "id": content.id.toString(),
                "title": content.title,
                "lyrics": null,
                "stageName": content.stageName,
                "filepath": content.filepath,
                "cover": content.cover,
                "thumb": content.media!.thumb,
                "thumbnail": content.media!.thumbnail,
                "isCoverLocal": false,
                "description": content.description,
                "artistId": content.userid,
              },
          ]
        };
        PlayerModel playerModel = PlayerModel.fromJson(json);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreatePlaylists(playerModel: playerModel),
          ),
        );
        break;
      case 2:
        _onMorePopupDownload(data);
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (content) => AddReport(
              albumId: null,
              postId: null,
              radioId: null,
              bannerId: data.id.toString(),
            ),
          ),
        );
        break;
      default:
    }
  }

  void _onMorePopupDownload(AllBannersData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "banner${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": "N/A",
      "description": "N/A",
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        for (var content in data.files!)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": null,
            "stageName": content.stageName,
            "filepath": content.filepath,
            "cover": content.cover,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": content.description,
            "artistId": content.userid,
            "downloaded": false,
            "localFile": null,
            "isDownloading": true,
          },
      ],
    };

    contentDownload(meta);
  }

  Future<void> _onTrackMore(
    dynamic action,
    Files? data,
  ) async {
    switch (action) {
      case 0:
        setState(() => _isLoading = true);
        String text = "${data!.title!} by ${data.stageName}";
        String imageUrl = data.media!.thumbnail!;
        String generatedLink = await _firebaseDynamicLink.createDynamicLink(
          albumId: null,
          albumUrlHash: null,
          singleMusicId: data.id,
          playlistid: null,
          imageUrl: imageUrl,
          title: text,
        );
        print(generatedLink);
        setState(() => _isLoading = false);
        shareContent(text: generatedLink);
        break;
      case 1:
        setState(() => _isLoading = true);
        saveDeleteContentFavorite(
          contentId: data!.id.toString(),
          state: () {
            setState(() => _isLoading = false);
          },
          type: "single",
        );
        break;
      case 2:
        Map<String, dynamic> json = {
          "data": [
            {
              "id": data!.id,
              "title": data.title,
              "lyrics": null,
              "stageName": data.stageName,
              "filepath": data.filepath,
              "cover": data.cover,
              "thumb": data.media!.thumb,
              "thumbnail": data.media!.thumbnail,
              "isCoverLocal": false,
              "description": data.description,
              "artistId": data.userid,
            },
          ]
        };
        PlayerModel playerModel = PlayerModel.fromJson(json);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreatePlaylists(playerModel: playerModel),
          ),
        );
        break;
      case 3:
        _onDownloadTrack(data!);
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (content) => AddReport(
              albumId: null,
              postId: data!.id,
              radioId: null,
            ),
          ),
        );
        break;
      default:
    }
  }

  Future<void> _recordJointContent(AllBannersData data) async {
    Map<dynamic, dynamic> meta = {
      "id": "banner${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": "$TITLE",
      "description": "N/A",
      "createAt": data.dateCreated,
      "content": [
        for (var content in data.files!)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": null,
            "stageName": content.stageName,
            "filepath": content.filepath,
            "cover": content.cover,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": content.description,
            "artistId": content.userid,
          },
      ]
    };
    String? encodedData = await getHive("recentPlayJoint");
    if (encodedData == null) {
      await saveHive(key: "recentPlayJoint", data: json.encode([meta]));
    } else {
      List<dynamic> decodedData = json.decode(encodedData);
      List<Map<dynamic, dynamic>> metaList =
          decodedData.cast<Map<dynamic, dynamic>>();

      for (int x = 0; x < metaList.length; ++x) {
        if ("banner${data.id}" == metaList[x]["id"]) {
          metaList.removeAt(x);
        }
      }
      List<Map<dynamic, dynamic>> newMetaList = [meta] + metaList;
      await saveHive(key: "recentPlayJoint", data: json.encode(newMetaList));
      log("encodedData $encodedData");
    }
    Repository repo = new Repository();
    repo.fetchRecentlyPlayedJoint();
  }

  Future<void> _onPlayAll() async {
    setState(() => _isLoading = true);
    _recordJointContent(widget.allBannersData!);
    Map<String, dynamic> json = {
      "data": [
        for (int x = 0; x < widget.allBannersData!.files!.length; ++x)
          {
            "id": widget.allBannersData!.files![x].id,
            "title": widget.allBannersData!.files![x].title,
            "lyrics": "",
            "stageName": widget.allBannersData!.files![x].stageName,
            "filepath": widget.allBannersData!.files![x].filepath,
            "isDownloaded": x == 0,
            "cover": widget.allBannersData!.files![x].cover,
            "thumbnail": widget.allBannersData!.files![x].media!.thumbnail,
            "thumb": widget.allBannersData!.files![x].media!.thumb,
            "isCoverLocal": false,
            "description": widget.allBannersData!.files![x].description,
            "artistId": widget.allBannersData!.files![x].userid,
          },
      ],
    };
    onHideOverlay();
    setState(() => _isLoading = false);
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

  void _onDeleteDialog() {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onDelete(),
      type: CoolAlertType.warning,
      text:
          "You are about to delete this content. Understant that deleting is permanent, and can't be undone",
      confirmBtnText: "Delete Forever",
    );
  }

  void _onEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBanner(
          allBannersData: widget.allBannersData,
        ),
      ),
    );
  }

  Future<void> _onDelete() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: REMOVEBANNER_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "createuser": userModel!.data!.user!.userid,
          "banners": json.encode([widget.allBannersData!.id.toString()]),
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

  Future<void> _onTrack(Files file) async {
    setState(() => _isLoading = true);

    Map<String, dynamic> json = {
      "data": [
        {
          "id": file.id,
          "title": file.title,
          "lyrics": "",
          "stageName": file.stageName,
          "filepath": file.filepath,
          "cover": file.cover,
          "isCoverLocal": false,
          "description": file.description,
        },
        for (int x = 0; x < widget.allBannersData!.files!.length; ++x)
          if (file.id != widget.allBannersData!.files![x].id)
            {
              "id": widget.allBannersData!.files![x].id,
              "title": widget.allBannersData!.files![x].title,
              "lyrics": "",
              "stageName": widget.allBannersData!.files![x].stageName,
              "filepath": widget.allBannersData!.files![x].filepath,
              "cover": widget.allBannersData!.files![x].cover,
              "thumbnail": widget.allBannersData!.files![x].media!.thumbnail,
              "thumb": widget.allBannersData!.files![x].media!.thumb,
              "isCoverLocal": false,
              "description": widget.allBannersData!.files![x].description,
              "isQueue": true,
              "artistId": widget.allBannersData!.files![x].userid,
            },
      ],
    };
    onHideOverlay();

    PlayerModel playerModel = PlayerModel.fromJson(json);
    if (playerModel.data![0].filepath!.split("/").last.contains("mp4")) {
      setState(() => _isLoading = false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoMusicPlayer(playerModel),
        ),
      );
    } else {
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
}
