import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/allMusicNewMusicModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allMusicNewMusicProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import '../album/albumsDetails/albumsDetailsPage.dart';
import 'widget/newMusicFullWidget.dart';
import 'widget/newMusicWidget.dart';

class NewMusic extends StatefulWidget {
  final int? noOfContentDisplay;
  final AllMusicAllSongsModel? allMusicModel;
  final String? selectedGenre;

  NewMusic({
    this.noOfContentDisplay,
    @required this.allMusicModel,
    this.selectedGenre = "all",
  });

  @override
  State<NewMusic> createState() => _NewMusicState();
}

class _NewMusicState extends State<NewMusic> {
  String _genreDisplay = "all";

  PaginatedItemsResponse<MusicData>? _postsResponse;

  PaginatedItemsResponse<MusicData>? get postsResponse => _postsResponse;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  void initState() {
    super.initState();
    _genreDisplay = widget.selectedGenre!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allMusicNewMusicModelStream,
      initialData: allMusicNewMusicModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print(snapshot);
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
        return shimmerItem(useGrid: widget.noOfContentDisplay != -1000);
      },
    );
  }

  Widget _mainContent(AllMusicNewMusicModel model) {
    _postsResponse = PaginatedItemsResponse<MusicData>(
      listItems: Iterable.castFrom(model.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );
    return widget.noOfContentDisplay == -1000
        ? newMusicFullWidget(
            context: context,
            onMusic: (MusicData data) => _onMusic(data, model),
            model: model,
            selectedGenre: _genreDisplay,
            allMusicModel: widget.allMusicModel,
            onGenre: (String genre) {
              _genreDisplay = genre;
              setState(() {});
            },
            fetchPageData: (bool) async {
              _postsResponse = PaginatedItemsResponse<MusicData>(
                listItems: Iterable.castFrom(model.data!),
                // no support for pagination for current api
                paginationKey: null,
                idGetter: (post) => post.id.toString(),
              );
              return _postsResponse;
            },
            response: postsResponse,
            onMusicMore: (MusicData data) => _onTrackMore(data, model),
            onMusicPlay: (MusicData data) => _onPlayTrack(data, model),
          )
        : newMusicWidget(
            context: context,
            onSeeAll: () => _onSeeAll(),
            onMusic: (MusicData data) => _onMusic(data, model),
            model: model,
            selectedGenre: widget.selectedGenre,
            onTrackMore: (MusicData data) => _onTrackMore(data, model),
            onPlayTrack: (MusicData data) => _onPlayTrack(data, model),
          );
  }

  void _onPlayTrack(MusicData data, AllMusicNewMusicModel model) {
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

  void _onTrackMore(MusicData data, AllMusicNewMusicModel model) {
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

  void _onDownloadSingle(MusicData data) {
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

  void _onFavorite(MusicData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "single",
    );
  }

  Future<void> _onShare(MusicData data) async {
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

  void _onReport(MusicData data) {
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

  void _onArtistProfile(MusicData musicData) {
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

  void _onAddToPlaylist(MusicData data) {
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
          appBar: AppBar(title: Text("New Releases")),
          body: NewMusic(
            noOfContentDisplay: -1000,
            allMusicModel: widget.allMusicModel,
            selectedGenre: widget.selectedGenre,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getJson(MusicData data, AllMusicNewMusicModel model) {
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
                "thumbnail": modelData.media!.thumbnail,
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

  void _onMusic(MusicData data, AllMusicNewMusicModel model) {
    QueueModel queueModel = QueueModel.fromJson(_getJson(data, model));

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
