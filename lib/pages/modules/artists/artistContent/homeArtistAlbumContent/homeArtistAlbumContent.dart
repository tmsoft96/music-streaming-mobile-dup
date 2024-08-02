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
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allAlbumProvider.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/homeArtistAlbumContentWidget.dart';

class HomeArtistAlbumContent extends StatefulWidget {
  final int? noOfContentDisplay;
  final String? artistId;

  HomeArtistAlbumContent({
    this.noOfContentDisplay,
    @required this.artistId,
  });

  @override
  State<HomeArtistAlbumContent> createState() => _HomeArtistAlbumContentState();
}

class _HomeArtistAlbumContentState extends State<HomeArtistAlbumContent> {
  int _tabIndex = 0;

  AllAlbumProvider _provider = new AllAlbumProvider();

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  bool _isLoading = false;
  String _loadingMsg = "";
  double? _loadingPercentage;

  @override
  void initState() {
    super.initState();
    _provider.get(isLoad: true, status: "0", filterArtistId: widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allAlbumModelStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return widget.noOfContentDisplay == -1000
                ? emptyBox(context, msg: "${snapshot.data.msg}")
                : emptyBoxLinear(context, msg: "${snapshot.data.msg}");
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

  Widget _mainContent(AllAlbumModel model) {
    return Stack(
      children: [
        homeArtistAlbumContentWidget(
          context: context,
          noOfContentDisplay: widget.noOfContentDisplay,
          onAlbum: (AllAlbumData data) => _onContent(data),
          model: model,
          onTap: (int index) => _onTap(index),
          tabIndex: _tabIndex,
          artistId: widget.artistId ?? userModel!.data!.user!.userid!,
          onAlbumMore: (AllAlbumData data) => _onTrackMore(data),
          onPlayAlbum: (AllAlbumData data) => _onPlayTrack(data),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  void _onPlayTrack(AllAlbumData albumData) {
    Map<String, dynamic> json = {
      "data": [
        for (var data in albumData.files!)
          {
            "id": data.id,
            "title": data.name,
            "lyrics": data.lyrics,
            "stageName": albumData.stageName,
            "filepath": data.filepath,
            "cover": data.cover,
            "thumb": data.cover,
            "thumbnail": albumData.media!.thumbnail,
            "isCoverLocal": false,
            "description": albumData.description,
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

  void _onTrackMore(AllAlbumData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.media!.thumb,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.stageName,
          title: data.name,
          artistPicture: null,
          onAddToPlaylist: () => _onAddToPlaylist(data),
          onArtistProfile: () => _onArtistProfile(data),
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onContent(data),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownload(data),
          contentId: data.id.toString(),
          contentType: 'album',
        );
      },
    );
  }

  void _onDownload(AllAlbumData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "album${data.id}",
      "cover": data.cover,
      "title": data.name,
      "artistName": data.stageName,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        for (var content in data.files!)
          {
            "id": content.id,
            "title": content.name,
            "lyrics": content.lyrics,
            "stageName": data.stageName,
            "filepath": content.filepath,
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

  Future<void> _onShare(AllAlbumData data) async {
    String text = "${data.name!} by ${data.stageName}";

    String imageUrl = data.media!.thumbnail!;

    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String generatedLink = await _firebaseDynamicLink.createDynamicLink(
      albumId: data.id.toString(),
      albumUrlHash: data.urlHash,
      singleMusicId: null,
      playlistid: null,
      imageUrl: imageUrl,
      title: text,
    );
    print(generatedLink);

    shareContent(text: generatedLink);
  }

  void _onReport(AllAlbumData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (content) => AddReport(
          albumId: data.id.toString(),
          postId: null,
          radioId: null,
        ),
      ),
    );
  }

  void _onArtistProfile(AllAlbumData musicData) {
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

  void _onAddToPlaylist(AllAlbumData albumData) {
    Map<String, dynamic> json = {
      "data": [
        for (var data in albumData.files!)
          {
            "id": data.id,
            "title": data.name,
            "lyrics": data.lyrics,
            "stageName": albumData.stageName,
            "filepath": data.filepath,
            "cover": data.cover,
            "thumb": data.cover,
            "thumbnail": albumData.media!.thumbnail,
            "isCoverLocal": false,
            "description": albumData.description,
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

  void _onFavorite(AllAlbumData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "album",
    );
  }

  Future<void> _onTap(int index) async {
    _tabIndex = index;
    toastContainer(text: "Loading", backgroundColor: GREEN);
    await _provider
        .get(
          isLoad: true,
          status: _tabIndex.toString(),
          filterArtistId: widget.artistId ?? userModel!.data!.user!.userid!,
        )
        .then((value) => setState(() {}));
  }

  void _onContent(AllAlbumData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allMusicData: null,
          allAlbumData: data,
        ),
      ),
    );
  }
}
