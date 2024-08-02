import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/allSongsFullWidget.dart';
import 'widget/allSongsWidget.dart';

class AllSongs extends StatefulWidget {
  final int? noOfContentDisplay;
  final AllMusicAllSongsModel? allMusicModel;
  final String? selectedGenre;

  AllSongs({
    this.noOfContentDisplay,
    @required this.allMusicModel,
    this.selectedGenre = "all",
  });

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  String _genreDisplay = "all";

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  void initState() {
    super.initState();
    _genreDisplay = widget.selectedGenre!;
  }

  PaginatedItemsResponse<MusicAllSongsData>? _postsResponse;

  PaginatedItemsResponse<MusicAllSongsData>? get postsResponse =>
      _postsResponse;

  @override
  Widget build(BuildContext context) {
    _postsResponse = PaginatedItemsResponse<MusicAllSongsData>(
      listItems: Iterable.castFrom(widget.allMusicModel!.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );

    return widget.noOfContentDisplay == -1000
        ? allSongsFullWidget(
            context: context,
            onMusic: (MusicAllSongsData data) => _onSong(data),
            model: widget.allMusicModel!,
            selectedGenre: _genreDisplay,
            // allMusicModel: widget.allMusicModel,
            onGenre: (String genre) {
              _genreDisplay = genre;
              setState(() {});
            },
            fetchPageData: (bool) async {
              _postsResponse = PaginatedItemsResponse<MusicAllSongsData>(
                listItems: Iterable.castFrom(widget.allMusicModel!.data!),
                // no support for pagination for current api
                paginationKey: null,
                idGetter: (post) => post.id.toString(),
              );
              return _postsResponse;
            },
            response: postsResponse,
            onMusicMore: (MusicAllSongsData data) => _onTrackMore(data),
            onMusicPlay: (MusicAllSongsData data) =>
                _onPlayTrack(data, widget.allMusicModel!),
          )
        : allSongsWidget(
            context: context,
            onSeeAll: () => _onSeeAll(),
            onMusic: (MusicAllSongsData data) => _onSong(data),
            model: widget.allMusicModel!,
            selectedGenre: widget.selectedGenre,
            onTrackMore: (MusicAllSongsData data) => _onTrackMore(data),
            onPlayTrack: (MusicAllSongsData data) =>
                _onPlayTrack(data, widget.allMusicModel!),
          );
  }

  void _onPlayTrack(MusicAllSongsData data, AllMusicAllSongsModel model) {
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

  void _onTrackMore(MusicAllSongsData data) {
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
          onMoreInfo: () => _onSong(data),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownloadSingle(data),
          contentId: data.id.toString(),
          contentType: 'single',
        );
      },
    );
  }

  void _onDownloadSingle(MusicAllSongsData data) {
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

  void _onFavorite(MusicAllSongsData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "single",
    );
  }

  Future<void> _onShare(MusicAllSongsData data) async {
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

  void _onReport(MusicAllSongsData data) {
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

  void _onArtistProfile(MusicAllSongsData musicData) {
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

  void _onAddToPlaylist(MusicAllSongsData data) {
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

  void _onSeeAll() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("All Songs")),
          body: AllSongs(
            noOfContentDisplay: -1000,
            allMusicModel: widget.allMusicModel,
            selectedGenre: widget.selectedGenre,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getJson(
      MusicAllSongsData data, AllMusicAllSongsModel model) {
    String selectedGenre = widget.noOfContentDisplay == -1000
        ? _genreDisplay
        : widget.selectedGenre!;
    print(selectedGenre);
    Map<String, dynamic> rawJson = {
      "data": [
        if (selectedGenre == "all")
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
                "thumbnail": data.media!.thumbnail,
                "isCoverLocal": false,
                "description": modelData.description,
                "artistId": modelData.userid,
              },
        if (selectedGenre != "all")
          for (var modelData in model.data!)
            for (var genre in modelData.genres!)
              if (genre.genre!.name == selectedGenre && modelData.id != data.id)
                {
                  "id": modelData.id,
                  "title": modelData.title,
                  "lyrics": modelData.lyrics,
                  "stageName": modelData.stageName,
                  "filepath": modelData.filepath,
                  "cover": modelData.media!.normal,
                  "thumb": modelData.media!.thumb,
                  "thumbnail": data.media!.thumbnail,
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

  void _onSong(MusicAllSongsData data) {
    QueueModel queueModel =
        QueueModel.fromJson(_getJson(data, widget.allMusicModel!));
    AllMusicData allMusicData = new AllMusicData.fromJson(data.toJson());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allAlbumData: null,
          allMusicData: allMusicData,
          queueModel: queueModel,
        ),
      ),
    );
  }
}
