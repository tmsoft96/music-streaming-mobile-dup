import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/generalPopup.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/checkFollowingModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/updateContent/updateContent.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/commentSection/commentSection.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/checkFollowingProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:rally/utils/videoPlayer/videoPlayer.dart';

import 'widget/albumsDetailsWidget.dart';

class AlbumsDetailsPage extends StatefulWidget {
  final AllMusicData? allMusicData;
  final AllAlbumData? allAlbumData;
  final QueueModel? queueModel;

  AlbumsDetailsPage({
    @required this.allMusicData,
    @required this.allAlbumData,
    this.queueModel,
  });

  @override
  State<AlbumsDetailsPage> createState() => _AlbumsDetailsPageState();
}

class _AlbumsDetailsPageState extends State<AlbumsDetailsPage> {
  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  int _tabIndex = 0;
  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  CheckFollowingModel? _checkFollowingModel;

  @override
  void initState() {
    super.initState();
    _loadCheckFollowing();
  }

  Future<void> _loadCheckFollowing() async {
    CheckFollowingProvider provider = CheckFollowingProvider();
    await loadAllCheckFollowingMapOffline(
      userId: widget.allMusicData != null
          ? widget.allMusicData!.userid
          : widget.allAlbumData!.userid,
      followId: userModel!.data!.user!.userid,
    );
    if (checkFollowingMapOffline != null) {
      _checkFollowingModel = CheckFollowingModel.fromJson(
        json: checkFollowingMapOffline,
        httpMsg: "Offline Data",
      );
      setState(() {});
    }
    _checkFollowingModel = await provider.fetch(
      userId: widget.allMusicData != null
          ? widget.allMusicData!.userid
          : widget.allAlbumData!.userid,
      followId: userModel!.data!.user!.userid,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "${widget.allMusicData != null ? widget.allMusicData!.title : widget.allAlbumData!.name}",
        ),
        actions: [
          IconButton(
            onPressed: () => _onShareContent(),
            icon: Icon(Icons.share),
          ),
          if (userModel!.data!.user!.userid ==
              (widget.allMusicData != null
                  ? widget.allMusicData!.userid
                  : widget.allAlbumData!.userid)) ...[
            IconButton(
              onPressed: () => _onEdit(),
              icon: Icon(FeatherIcons.edit),
            ),
            IconButton(
              onPressed: () => _onDeleteDialog(),
              icon: Icon(Icons.delete),
            ),
          ],
          generalPopup(
            onAction: (dynamic action) => _onMorePopUp(
              action,
              widget.allMusicData,
              widget.allAlbumData,
              null,
            ),
            contentId: widget.allMusicData != null
                ? widget.allMusicData!.id.toString()
                : widget.allAlbumData!.id.toString(),
            contentType: widget.allMusicData != null ? "single" : "album",
          ),
        ],
      ),
      body: Stack(
        children: [
          albumsDetailsWidget(
            context: context,
            onPlayAlbum: () => widget.allMusicData != null
                ? _onPlaySingle(null)
                : _onPlayEntireAlbum(),
            onTap: (int index) {
              setState(() {
                _tabIndex = index;
              });
            },
            onTrack: (AllMusicData data) => _onPlaySingle(null),
            onRating: (double rating) => _onRating(rating),
            tabIndex: _tabIndex,
            allMusicData: widget.allMusicData,
            onFollow: () => _onFollowArtist(),
            checkFollowingModel: _checkFollowingModel,
            allAlbumData: widget.allAlbumData,
            onAlbumTrack: (ContentFile file) => _onPlaySingle(file),
            onComment: () => _onComment(),
            onDownload: () => albumsDetialsContentDownloaded
                ? navigation(context: context, pageName: "downloadlibrary")
                : _onDownloadDialog(
                    allMusicData: widget.allMusicData,
                    albumData: widget.allAlbumData,
                  ),
            onFavorite: () => _onFavorite(null),
            onAlbumDownload: (ContentFile file) => _onDownloadContent(file),
            onAlbumTrackMore: (action, ContentFile file) => _onMorePopUp(
              action,
              null,
              null,
              file,
            ),
            onSingleDownload: () => albumsDetialsContentDownloaded
                ? navigation(context: context, pageName: "downloadlibrary")
                : _onDownloadDialog(
                    allMusicData: widget.allMusicData,
                    albumData: null,
                  ),
            onSingleTrackMore: (action) => _onMorePopUp(
              action,
              widget.allMusicData,
              widget.allAlbumData,
              null,
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

  void _onFavorite(ContentFile? contentFile) {
    setState(() => _isLoading = true);
    String contentId = contentFile != null
        ? contentFile.id.toString()
        : widget.allAlbumData != null
            ? widget.allAlbumData!.id.toString()
            : widget.allMusicData!.id.toString();
    String type = contentFile != null
        ? "single"
        : widget.allAlbumData != null
            ? "album"
            : "single";
    saveDeleteContentFavorite(
      contentId: contentId,
      state: () {
        setState(() => _isLoading = false);
      },
      type: type,
    );
  }

  void _onComment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommentSection(
          contentId: widget.allMusicData != null
              ? widget.allMusicData!.id.toString()
              : widget.allAlbumData!.id.toString(),
        ),
      ),
    );
  }

  Future<void> _onMorePopUp(
    dynamic action,
    AllMusicData? singleData,
    AllAlbumData? albumData,
    ContentFile? contentFile,
  ) async {
    switch (action) {
      case 0:
        setState(() => _isLoading = true);
        String imageUrl = singleData != null
            ? singleData.media!.thumbnail!
            : albumData!.media!.thumbnail!;

        String text = singleData != null
            ? "${singleData.title!} by ${singleData.stageName}"
            : contentFile != null
                ? "${contentFile.name!} by ${widget.allAlbumData!.stageName}"
                : "${albumData!.name!} by ${albumData.stageName}";

        String generatedLink = await _firebaseDynamicLink.createDynamicLink(
          albumId: albumData != null ? albumData.id.toString() : null,
          albumUrlHash: albumData != null ? albumData.urlHash : null,
          singleMusicId: singleData != null
              ? singleData.id.toString()
              : contentFile != null
                  ? contentFile.id.toString()
                  : null,
          playlistid: null,
          imageUrl: imageUrl,
          title: text,
        );
        print(generatedLink);
        setState(() => _isLoading = false);

        shareContent(text: generatedLink);
        break;
      case 1:
        _onFavorite(contentFile);
        break;
      case 2:
        Map<String, dynamic> json = {
          "data": [
            if (singleData != null)
              {
                "id": singleData.id,
                "title": singleData.title,
                "lyrics": singleData.lyrics,
                "stageName": singleData.stageName,
                "filepath": singleData.filepath,
                "cover": singleData.media!.normal,
                "thumb": singleData.media!.thumb,
                "thumbnail": singleData.media!.thumbnail,
                "isCoverLocal": false,
                "description": singleData.description,
                "artistId": singleData.userid,
              },
            if (albumData != null)
              for (var file in albumData.files!)
                {
                  "id": file.id,
                  "title": file.name,
                  "lyrics": file.lyrics,
                  "stageName": albumData.stageName,
                  "filepath": file.filepath,
                  "cover": albumData.media!.normal,
                  "thumb": albumData.media!.thumb,
                  "thumbnail": albumData.media!.thumbnail,
                  "isCoverLocal": false,
                  "description": albumData.description,
                  "artistId": albumData.userid,
                },
            if (contentFile != null)
              {
                "id": contentFile.id,
                "title": contentFile.name,
                "lyrics": contentFile.lyrics,
                "stageName": widget.allAlbumData!.stageName,
                "filepath": contentFile.filepath,
                "cover": widget.allAlbumData!.media!.normal,
                "thumb": widget.allAlbumData!.media!.thumb,
                "thumbnail": widget.allAlbumData!.media!.thumbnail,
                "isCoverLocal": false,
                "description": widget.allAlbumData!.description,
                "artistId": widget.allAlbumData!.userid,
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
        if (albumsDetialsContentDownloaded) {
          navigation(context: context, pageName: "downloadlibrary");
          return;
        }
        if (contentFile == null)
          _onDownload(allMusicData: singleData, albumData: albumData);
        else
          _onDownloadContent(contentFile);
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (content) => AddReport(
              albumId: albumData != null ? albumData.id.toString() : null,
              postId: contentFile != null
                  ? contentFile.id.toString()
                  : singleData != null
                      ? singleData.id.toString()
                      : null,
              radioId: null,
            ),
          ),
        );
        break;
      default:
    }
  }

  void _onDownloadContent(ContentFile data) {
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
      "title": data.name,
      "artistName": widget.allAlbumData!.stageName,
      "description": widget.allAlbumData!.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        {
          "id": data.id,
          "title": data.name,
          "lyrics": data.lyrics,
          "stageName": widget.allAlbumData!.stageName,
          "filepath": data.filepath,
          "cover": data.cover,
          "thumbnail": widget.allAlbumData!.media!.thumbnail,
          "isCoverLocal": false,
          "description": widget.allAlbumData!.stageName,
          "artistId": data.userid,
          "downloaded": false,
          "localFile": null,
          "isDownloading": true,
        },
      ],
    };

    contentDownload(meta);
  }

  Future<void> _onShareContent() async {
    setState(() => _isLoading = true);
    String imageUrl = widget.allAlbumData != null
        ? widget.allAlbumData!.media!.thumbnail!
        : widget.allMusicData!.media!.thumbnail!;

    String text = widget.allAlbumData != null
        ? "${widget.allAlbumData!.name!} ${widget.allAlbumData!.stageName == null ? '' : 'by ${widget.allAlbumData!.stageName}'}"
        : "${widget.allMusicData!.title!} by ${widget.allMusicData!.stageName ?? widget.allMusicData!.user!.name}";

    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: widget.allAlbumData != null
          ? widget.allAlbumData!.id.toString()
          : null,
      albumUrlHash:
          widget.allAlbumData != null ? widget.allAlbumData!.urlHash : null,
      singleMusicId: widget.allMusicData != null
          ? widget.allMusicData!.id.toString()
          : null,
      playlistid: null,
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);
    setState(() => _isLoading = false);

    shareContent(text: generatedLink);
  }

  void _onDownloadDialog({
    @required AllMusicData? allMusicData,
    @required AllAlbumData? albumData,
  }) {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () {
        navigation(context: context, pageName: "back");
        _onDownload(
          allMusicData: allMusicData,
          albumData: albumData,
        );
      },
      type: CoolAlertType.info,
      text:
          "You can now play this content data-free in the app in the download section",
      confirmBtnText: "Download",
    );
  }

  Future<void> _onDownload({
    @required AllMusicData? allMusicData,
    @required AllAlbumData? albumData,
  }) async {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {};
    if (allMusicData != null) {
      meta = {
        "id": "single${allMusicData.id}",
        "cover": allMusicData.media!.thumb,
        "title": allMusicData.title,
        "artistName": allMusicData.stageName,
        "description": allMusicData.description,
        "createAt": DateTime.now().millisecondsSinceEpoch,
        "fileDownloaded": false,
        "content": [
          {
            "id": allMusicData.id,
            "title": allMusicData.title,
            "lyrics": allMusicData.lyrics,
            "stageName": allMusicData.stageName,
            "filepath": allMusicData.filepath,
            "cover": allMusicData.media!.thumb,
            "thumbnail": allMusicData.media!.thumbnail,
            "isCoverLocal": false,
            "description": allMusicData.description,
            "artistId": allMusicData.userid,
            "downloaded": false,
            "localFile": null,
            "isDownloading": true,
          },
        ],
      };
    }

    if (albumData != null) {
      meta = {
        "id": "album${albumData.id}",
        "cover": albumData.media!.thumb,
        "title": albumData.name,
        "artistName": albumData.stageName,
        "description": albumData.description,
        "createAt": DateTime.now().millisecondsSinceEpoch,
        "fileDownloaded": false,
        "content": [
          for (var data in albumData.files!)
            {
              "id": data.id,
              "title": data.name,
              "lyrics": data.lyrics,
              "stageName": albumData.stageName,
              "filepath": data.filepath,
              "cover": albumData.media!.thumb,
              "thumbnail": albumData.media!.thumbnail,
              "isCoverLocal": false,
              "description": albumData.description,
              "artistId": data.userid,
              "downloaded": false,
              "localFile": null,
              "isDownloading": true,
            },
        ],
      };
    }

    contentDownload(meta);
  }

  void _onEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateContent(
          allMusicData: widget.allMusicData,
          allAlbumData: widget.allAlbumData,
        ),
      ),
    );
  }

  void _onDeleteDialog() {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onDelete(),
      type: CoolAlertType.warning,
      text:
          "You are about to delete this content. Understand that deleting is permanent, and can't be undone",
      confirmBtnText: "Delete Forever",
    );
  }

  Future<void> _onDelete() async {
    navigation(context: context, pageName: "back");
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint:
            widget.allMusicData != null ? POSTDELETE_URL : DELETEALBUMS_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: widget.allMusicData != null
            ? {
                "userid": userModel!.data!.user!.userid,
                "posts": json.encode([widget.allMusicData!.id]),
              }
            : {
                "userid": userModel!.data!.user!.userid,
                "albums": json.encode([widget.allAlbumData!.id]),
              },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
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

  Future<void> _onFollowArtist() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: FOLLOW_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": widget.allMusicData != null
              ? widget.allMusicData!.userid
              : widget.allAlbumData!.userid,
          "follower": userModel!.data!.user!.userid,
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      await _loadCheckFollowing();
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  Future<void> _onRating(double rating) async {
    setState(() => _isLoading = true);
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: RATEMUSIC_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "userid": userModel!.data!.user!.userid,
          "post_id": widget.allMusicData!.id!.toString(),
          "rate": rating.round().toString(),
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      // allMusicBloc.fetch(null);
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  Future<void> _recordJointContent(AllAlbumData data) async {
    Map<dynamic, dynamic> meta = {
      "id": "album${data.id}",
      "cover": data.media!.thumb,
      "title": data.name,
      "artistName": data.stageName,
      "description": data.description,
      "createAt": data.createdAt,
      "content": [
        for (var content in data.files!)
          {
            "id": content.id,
            "title": content.name,
            "lyrics": content.lyrics,
            "stageName": data.stageName,
            "filepath": content.filepath,
            "cover": data.media!.thumb,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": data.description,
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
        if ("album${data.id}" == metaList[x]["id"]) {
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

  Future<void> _onPlayEntireAlbum() async {
    setState(() => _isLoading = true);

    await _recordJointContent(widget.allAlbumData!);

    Map<String, dynamic> json = {
      "data": [
        for (int x = 0; x < widget.allAlbumData!.files!.length; ++x)
          {
            "id": widget.allAlbumData!.files![x].id,
            "title": widget.allAlbumData!.files![x].name,
            "lyrics": "",
            "stageName": widget.allAlbumData!.stageName,
            "filepath": widget.allAlbumData!.files![x].filepath,
            "isDownloaded": x == 0,
            "cover": widget.allAlbumData!.cover,
            "thumbnail": widget.allAlbumData!.media!.thumbnail,
            "isCoverLocal": false,
            "description": widget.allAlbumData!.description,
            "artistId": widget.allAlbumData!.userid,
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

  Future<void> _onPlaySingle(ContentFile? contentFile) async {
    setState(() => _isLoading = true);

    String fileUrl = widget.allMusicData != null
        ? widget.allMusicData!.filepath!
        : contentFile!.filepath!;

    Map<String, dynamic> json = {
      "data": [
        //singles
        if (widget.allMusicData != null) ...[
          {
            "id": widget.allMusicData!.id,
            "title": widget.allMusicData!.title,
            "lyrics": widget.allMusicData!.lyrics,
            "stageName": widget.allMusicData!.stageName,
            "filepath": fileUrl,
            "cover": widget.allMusicData!.media!.normal,
            "thumb": widget.allMusicData!.media!.thumb,
            "thumbnail": widget.allMusicData!.media!.thumbnail,
            "isCoverLocal": false,
            "description": widget.allMusicData!.description,
            "artistId": widget.allMusicData!.userid,
          },
          if (widget.queueModel != null) ...[
            for (var data in widget.queueModel!.data!)
              {
                "id": data.id,
                "title": data.title,
                "lyrics": data.lyrics,
                "stageName": data.stageName,
                "filepath": data.filepath,
                "cover": data.cover,
                "thumb": data.thumb,
                "thumbnail": data.thumbnail,
                "isCoverLocal": data.isCoverLocal,
                "description": data.description,
                "isQueue": true,
                "artistId": data.artistId,
                "isFileLocal": data.isFileLocal,
              },
          ],
        ],
        // album
        if (contentFile != null) ...[
          {
            "id": contentFile.id,
            "title": contentFile.name,
            "lyrics": contentFile.lyrics,
            "stageName": widget.allAlbumData!.stageName,
            "filepath": fileUrl,
            "cover": widget.allAlbumData!.media!.normal,
            "thumb": widget.allAlbumData!.media!.thumb,
            "thumbnail": widget.allAlbumData!.media!.thumbnail,
            "isCoverLocal": false,
            "description": widget.allAlbumData!.description,
            "artistId": widget.allAlbumData!.userid,
          },
          for (var data in widget.allAlbumData!.files!)
            if (contentFile.id != data.id)
              {
                "id": data.id,
                "title": data.name,
                "lyrics": data.lyrics,
                "stageName": widget.allAlbumData!.stageName,
                "filepath": data.filepath,
                "cover": data.cover,
                "thumb": data.cover,
                "thumbnail": widget.allAlbumData!.media!.thumbnail,
                "isCoverLocal": false,
                "description": widget.allAlbumData!.description,
                "isQueue": true,
                "artistId": widget.allAlbumData!.userid,
              },
        ],
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
