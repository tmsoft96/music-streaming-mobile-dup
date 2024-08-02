import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/hiveStorage.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/library/playlists/playlistDetails/playlistDetails.dart';
import 'package:rally/pages/modules/library/playlists/playlistDetails/widget/playlistReadMoreDialog.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allPlaylistsProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/playlistsWidget.dart';

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  String _genreDisplay = "all";
  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  void _loadFile() {
    Repository repo = new Repository();
    repo.fetchAllPlaylists(true, "", "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: allPlaylistsModelStream,
        initialData: allPlaylistsModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allPlaylistsModel == null
                  ? emptyBox(
                      context,
                      msg: "${snapshot.data.msg}",
                    )
                  : _mainContent(allPlaylistsModel!);
          } else if (snapshot.hasError) {
            return emptyBox(
              context,
              msg: "No data available",
            );
          }
          return shimmerItem();
        },
      ),
    );
  }

  Widget _mainContent(AllPlaylistsModel model) {
    return Stack(
      children: [
        playlistsWidget(
          context: context,
          model: model,
          onGenre: (String genre) => _onGenre(genre),
          onSeeAll: () {},
          onPlaylist: (AllPlaylistsData data) => _onPlaylist(data),
          genreDisplay: _genreDisplay,
          onPlayPlaylist: (AllPlaylistsData data) => _onPlayPlaylist(data),
          onPlaylistMore: (AllPlaylistsData data) => _onTrackMore(data),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
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

  Future<void> _onPlayPlaylist(AllPlaylistsData? data) async {
    setState(() => _isLoading = true);
    await _recordJointContent(data!);

    Map<String, dynamic> json = {
      "data": [
        for (var content in data.content!)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": content.lyrics,
            "stageName": content.stageName,
            "filepath": content.filepath,
            "cover": content.cover,
            "thubnail": content.thumbnail,
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
          onMoreInfo: () => _onReadMore(data),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownload(data),
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

  void _onDownload(AllPlaylistsData data) {
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
            "thumbnail": content.thumbnail,
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

  Future<void> _onShare(AllPlaylistsData data) async {
    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String imageUrl = data.media!.thumbnail!;
    String text = "${data.title!} by ${data.user!.stageName}";

    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: null,
      albumUrlHash: null,
      singleMusicId: null,
      playlistid: data.id.toString(),
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);

    shareContent(text: generatedLink);
  }

  void _onReadMore(AllPlaylistsData data) {
    showDialog(
      context: context,
      builder: (context) => playlistReadMoreDialog(data),
    );
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
            "thumbnail": data.thumbnail,
            "thumb": data.cover,
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
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "playlist",
    );
  }

  void _onGenre(String genre) {
    if (genre == "mine")
      navigation(context: context, pageName: "myplaylists");
    else {
      _genreDisplay = genre;
      setState(() {});
    }
  }

  void _onPlaylist(AllPlaylistsData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaylistDetails(data),
      ),
    );
  }
}
