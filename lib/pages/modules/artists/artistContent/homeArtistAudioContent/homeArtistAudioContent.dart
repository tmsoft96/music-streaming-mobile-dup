import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/homeArtistContentWidget.dart';

class HomeArtistAudioContent extends StatefulWidget {
  final int? noOfContentDisplay;
  final String? artistId;

  HomeArtistAudioContent({
    this.noOfContentDisplay,
    @required this.artistId,
  });

  @override
  _HomeArtistAudioContentState createState() => _HomeArtistAudioContentState();
}

class _HomeArtistAudioContentState extends State<HomeArtistAudioContent> {
  AllMusicProvider _provider = AllMusicProvider();

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  bool _isLoading = false;
  String _loadingMsg = "";
  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _provider.get(
        isLoad: false,
        filterArtistId: widget.artistId ?? userModel!.data!.user!.userid!);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allMusicModelStream,
      initialData: allMusicModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return allMusicModel == null
                ? widget.noOfContentDisplay == -1000
                    ? emptyBox(context, msg: "${snapshot.data.msg}")
                    : emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allMusicModel!);
        } else if (snapshot.hasError) {
          return widget.noOfContentDisplay == -1000
              ? emptyBox(context, msg: "No data available")
              : emptyBoxLinear(context, msg: "No data available");
        }
        return widget.noOfContentDisplay == 1
            ? shimmerItem(numOfItem: 1)
            : shimmerItem();
      },
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return Stack(
      children: [
        homeArtistAudioContentWidget(
          context: context,
          noOfContentDisplay: widget.noOfContentDisplay,
          onContent: (AllMusicData data) => _onContent(data),
          model: model,
          onContentMore: (AllMusicData data) => _onTrackMore(data),
          onContentPlay: (AllMusicData data) => _onPlayTrack(data),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  void _onPlayTrack(AllMusicData data) {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.cover,
          "thumb": data.media!.thumb,
          "thumbnail": data.media!.thumbnail,
          "isCoverLocal": false,
          "description": data.description,
          "artistId": data.userid,
        },
      ],
    };
    PlayerModel playerModel = PlayerModel.fromJson(json);
    onHideOverlay();
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

  void _onTrackMore(AllMusicData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.media!.thumb,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.stageName,
          title: data.title,
          artistPicture: data.user!.picture,
          onAddToPlaylist: () => _onAddToPlaylist(data),
          onArtistProfile: () => _onArtistProfile(data),
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onContent(data),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownload(data),
          contentId: data.id.toString(),
          contentType: 'single',
        );
      },
    );
  }

  void _onDownload(AllMusicData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "single${data.id}",
      "cover": data.media!.thumb,
      "title": data.title,
      "artistName": data.user!.stageName ?? data.user!.name,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        {
          "id": data.id.toString(),
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.media!.thumb,
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

  Future<void> _onShare(AllMusicData data) async {
    String text = "${data.title!} by ${data.stageName}";

    String imageUrl = data.media!.thumbnail!;

    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: null,
      albumUrlHash: null,
      singleMusicId: data.id.toString(),
      playlistid: null,
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);

    shareContent(text: generatedLink);
  }

  void _onReport(AllMusicData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (content) => AddReport(
          albumId: null,
          postId: data.id.toString(),
          radioId: null,
        ),
      ),
    );
  }

  void _onArtistProfile(AllMusicData musicData) {
    for (var data in allArtistsModel!.data!)
      if (musicData.userid == data.userid) {
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

  void _onAddToPlaylist(AllMusicData data) {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
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
  }

  void _onFavorite(AllMusicData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "single",
    );
  }

  void _onContent(AllMusicData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allMusicData: data,
          allAlbumData: null,
        ),
      ),
    );
  }
}
