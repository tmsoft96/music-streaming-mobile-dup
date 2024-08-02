import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/coolAlertDialog.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/http/httpChecker.dart';
import 'package:rally/config/http/httpRequester.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/config/services.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/library/playlists/playlistDetails/widget/playlistDetailsWidget.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/playlistReadMoreDialog.dart';

class PlaylistDetails extends StatefulWidget {
  final AllPlaylistsData? allPlaylistsData;

  PlaylistDetails(this.allPlaylistsData);

  @override
  State<PlaylistDetails> createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          playlistDetailsWidget(
            context: context,
            allPlaylistsData: widget.allPlaylistsData,
            onBack: () => navigation(context: context, pageName: "back"),
            onMorePopUp: () => _onTrackMore(widget.allPlaylistsData!),
            onReadMore: () => _onReadMore(),
            onMusic: (Content content) => _onPlay(content),
            onPlayAll: () => _onPlay(null),
            onDeletePlaylistConent: (Content content) =>
                _onDeletePlaylistContentDialog(content),
            onDownloadAll: () => _onDownloadPlaylist(widget.allPlaylistsData!),
            onFavorite: () => _onFavorite(widget.allPlaylistsData!),
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

  void _onDownloadPlaylist(AllPlaylistsData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "playlist${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": data.user!.stageName ?? data.user!.name,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        for (var content in data.content!)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": content.lyrics,
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

  void _onTrackMore(AllPlaylistsData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.media!.thumb,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.user!.stageName ?? data.user!.name,
          title: data.title,
          artistPicture: data.user!.picture,
          onAddToPlaylist: () => _onAddToPlaylist(data),
          onArtistProfile: () => _onArtistProfile(data),
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onReadMore(),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownloadPlaylist(data),
          contentId: data.id.toString(),
          contentType: 'playlist',
        );
      },
    );
  }

  void _onReport(AllPlaylistsData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (content) => AddReport(
          albumId: null,
          postId: null,
          radioId: null,
          playlistId: data.id.toString(),
        ),
      ),
    );
  }

  Future<void> _onShare(AllPlaylistsData data) async {
    setState(() => _isLoading = true);
    String text =
        "${data.title!} by ${data.user!.stageName ?? data.user!.name}";
    String imageUrl = data.media!.thumbnail!;
    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: null,
      albumUrlHash: null,
      singleMusicId: null,
      playlistid: data.id.toString(),
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);
    setState(() => _isLoading = false);

    shareContent(text: generatedLink);
  }

  void _onArtistProfile(AllPlaylistsData playlistData) {
    for (var data in allArtistsModel!.data!)
      if (playlistData.userid == data.userid) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AllContents(
              artistId: data.userid,
              artistName: data.stageName ?? data.name,
              artistEmail: data.email,
              artistPicture: data.picture,
              followersCount: data.followersCount,
              followersUserIdList: [
                for (var followers in data.followers!) followers.followerId!
              ],
              streamsCount: data.streamsCount,
            ),
          ),
        );
        break;
      }
  }

  void _onAddToPlaylist(AllPlaylistsData playlistData) {
    Map<String, dynamic> json = {
      "data": [
        for (var data in playlistData.content!)
          {
            "id": data.id,
            "title": data.title,
            "lyrics": data.lyrics,
            "stageName": data.stageName,
            "filepath": data.filepath,
            "cover": data.cover,
            "thumb": data.cover,
            "thumbnail": data.thumbnail,
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
  }

  void _onFavorite(AllPlaylistsData data) {
    setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        setState(() => _isLoading = false);
      },
      type: "playlist",
    );
  }

  Future<void> _recordJointContent(AllPlaylistsData data) async {
    Map<dynamic, dynamic> meta = {
      "id": "playlist${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": data.user!.stageName ?? data.user!.name,
      "description": data.description,
      "createAt": data.createdAt,
      "content": [
        for (var content in data.content!)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": content.lyrics,
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
        if ("playlist${data.id}" == metaList[x]["id"]) {
          metaList.removeAt(x);
        }
      }
      List<Map<dynamic, dynamic>> newMetaList = [meta] + metaList;
      await saveHive(key: "recentPlayJoint", data: json.encode(newMetaList));
      // log("encodedData $encodedData");
    }
    Repository repo = new Repository();
    repo.fetchRecentlyPlayedJoint();
  }

  void _onDeletePlaylistContentDialog(Content content) {
    coolAlertDialog(
      context: context,
      onConfirmBtnTap: () => _onDeletePlaylistContent(content),
      type: CoolAlertType.warning,
      text: "You are about to delete this playlist content.",
      confirmBtnText: "Delete Forever",
    );
  }

  Future<void> _onDeletePlaylistContent(Content content) async {
    setState(() => _isLoading = true);
    navigation(context: context, pageName: "back");
    Map<String, dynamic> httpResult = await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: DELETECONTENTPLAYLISTSCONTENT_URL,
        method: HTTPMETHOD.POST,
        httpPostBody: {
          "content": json.encode([content.id.toString()]),
          "id": widget.allPlaylistsData!.id.toString(),
        },
      ),
      showToastMsg: false,
    );
    log("$httpResult");
    if (httpResult["ok"]) {
      Repository repo = new Repository();
      await repo.fetchAllPlaylists(true, userModel!.data!.user!.userid, "2");
      setState(() => _isLoading = false);
      toastContainer(text: httpResult["data"]["msg"], backgroundColor: GREEN);
      navigation(context: context, pageName: "back");
    } else {
      setState(() => _isLoading = false);
      httpResult["statusCode"] == 200
          ? toastContainer(
              text: httpResult["data"]["msg"], backgroundColor: RED)
          : toastContainer(text: httpResult["error"], backgroundColor: RED);
    }
  }

  Future<void> _onPlay(Content? content) async {
    setState(() => _isLoading = true);

    await _recordJointContent(widget.allPlaylistsData!);

    Map<String, dynamic> json = {
      "data": [
        if (content != null)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": content.lyrics,
            "stageName": content.stageName,
            "filepath": content.filepath,
            "cover": content.cover,
            "isCoverLocal": false,
            "description": content.description,
            "artistId": content.userid,
          },
        for (var content in widget.allPlaylistsData!.content!)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": content.lyrics,
            "stageName": content.stageName,
            "filepath": content.filepath,
            "cover": content.cover,
            "thumbnail": content.thumbnail,
            "isCoverLocal": false,
            "description": content.description,
            "artistId": content.userid,
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

  void _onReadMore() {
    showDialog(
      context: context,
      builder: (context) => playlistReadMoreDialog(widget.allPlaylistsData!),
    );
  }
}
