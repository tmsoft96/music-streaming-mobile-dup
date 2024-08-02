import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/artistContent/allArtistContent/allArtistContent.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/artistSongsWidget.dart';

class ArtistSongs extends StatefulWidget {
  final String? artistId, artistName;

  ArtistSongs({
    @required this.artistId,
    @required this.artistName,
  });

  @override
  State<ArtistSongs> createState() => _ArtistSongsState();
}

class _ArtistSongsState extends State<ArtistSongs> {
  String _artistName = "";

  AllMusicProvider _provider = AllMusicProvider();
  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  void initState() {
    super.initState();
    if (widget.artistName!.contains("ft"))
      _artistName = widget.artistName!.split("ft")[0];
    else
      _artistName = widget.artistName!;
    _provider.get(isLoad: false, filterArtistId: widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allMusicModelStream,
      // initialData: allMusicModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return emptyBoxLinear(context, msg: "${snapshot.data.msg}");
        } else if (snapshot.hasError) {
          return emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem();
      },
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return artistSongsWidget(
      context: context,
      onSeeAll: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AllArtistContent(
            artistId: widget.artistId,
          ),
        ),
      ),
      onSong: (AllMusicData data) => _onMusic(data, model),
      artistName: _artistName,
      model: model,
      onSongMore: (AllMusicData data) => _onTrackMore(data, model),
      onSongPlay: (AllMusicData data) => _onPlayTrack(data, model),
    );
  }

  void _onPlayTrack(AllMusicData data, AllMusicModel model) {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.media!.normal,
          "thumb": data.media!.thumb,
          "thumbnail": data.media!.thumbnail,
          "isCoverLocal": false,
          "description": data.description,
          "artistId": data.userid,
        },
        ..._getJson(data, model)["data"],
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

  void _onTrackMore(AllMusicData data, AllMusicModel model) {
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
          onArtistProfile: null,
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onMusic(data, model),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownloadSingle(data),
          contentId: data.id.toString(),
          contentType: 'single',
        );
      },
    );
  }

  void _onDownloadSingle(AllMusicData data) {
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

  Future<void> _onShare(AllMusicData data) async {
    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String text = "${data.title!} by ${data.stageName}";

    String imageUrl = data.media!.thumbnail!;
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

  Map<String, dynamic> _getJson(AllMusicData data, AllMusicModel model) {
    Map<String, dynamic> rawJson = {
      "data": [
        for (var modelData in model.data!)
          if (modelData.id != data.id)
            {
              "id": modelData.id,
              "title": modelData.title,
              "lyrics": modelData.lyrics,
              "stageName": modelData.stageName,
              "filepath": modelData.filepath,
              "cover": modelData.media!.normal,
              "thumb": modelData.media!.thumb,
              "thumbnail": modelData.media!.thumbnail,
              "isCoverLocal": false,
              "description": modelData.description,
              "artistId": modelData.userid,
            },
      ],
    };

    Map<String, dynamic> json = {
      "data": rawJson["data"].length >= 50
          ? rawJson["data"].take(50).toList()
          : rawJson["data"]
    };
    return json;
  }

  Future<void> _onMusic(AllMusicData data, AllMusicModel model) async {
    AllMusicModel s = model;
    Map<String, dynamic> json = {
      "data": [
        for (int x = 0; x < (s.data!.length > 50 ? 50 : s.data!.length); ++x)
          {
            "id": s.data![x].id,
            "title": s.data![x].title,
            "lyrics": s.data![x].lyrics,
            "stageName": s.data![x].stageName,
            "filepath": s.data![x].filepath,
            "cover": s.data![x].media!.normal,
            "thumb": s.data![x].media!.thumb,
            "thumbnail":s.data![x].media!.thumbnail,
            "isCoverLocal": false,
            "description": s.data![x].description,
            "isQueue": true,
          },
      ],
    };
    QueueModel queueModel = QueueModel.fromJson(json);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allMusicData: data,
          allAlbumData: null,
          queueModel: queueModel,
        ),
      ),
    );
    _provider.get(isLoad: true, filterArtistId: widget.artistId);
  }
}
