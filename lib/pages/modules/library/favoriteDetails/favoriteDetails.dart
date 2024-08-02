import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allAlbumHomepageModel.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/models/favoriteContentModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/library/playlists/playlistDetails/playlistDetails.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/allMusicAllSongsProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';

import 'widget/favoriteDetailsWidget.dart';

class FavoriteDetails extends StatefulWidget {
  final String? contentType;

  FavoriteDetails(this.contentType);

  @override
  State<FavoriteDetails> createState() => _FavoriteDetailsState();
}

class _FavoriteDetailsState extends State<FavoriteDetails> {
  PaginatedItemsResponse<String>? _postsResponse;

  PaginatedItemsResponse<String>? get postsResponse => _postsResponse;
  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  bool _isLoading = false;

  String _loadingMsg = "";

  double? _loadingPercentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contentType == "single"
              ? "Favorite Songs"
              : widget.contentType == "playlist"
                  ? "Favorite Playlists"
                  : "Favorite Album",
        ),
      ),
      body: StreamBuilder(
        stream: favoriteContentModelStream,
        initialData: favoriteContentModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _mainContent(snapshot.data);
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem(numOfItem: 7);
        },
      ),
    );
  }

  Widget _mainContent(FavoriteContentModel model) {
    _postsResponse = PaginatedItemsResponse<String>(
      listItems: Iterable.castFrom(model.contentIdList!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post,
    );

    return Stack(
      children: [
        favoriteDetailsWidget(
          context: context,
          model: model,
          onSingle: (MusicAllSongsData data) => _onMusic(data, model),
          fetchPageData: (bool) async {
            _postsResponse = PaginatedItemsResponse<String>(
              listItems: Iterable.castFrom(model.contentIdList!),
              // no support for pagination for current api
              paginationKey: null,
              idGetter: (post) => post,
            );
            return _postsResponse;
          },
          response: postsResponse,
          onDownloadSingle: (MusicAllSongsData data) => _onDownloadSingle(data),
          contentType: widget.contentType,
          onSingleMore: (action, MusicAllSongsData data) =>
              _onTrackMore(action, data, null),
          onAlbum: (AllAlbumHomepageData data) => _onAlbum(data),
          onAlbumMore: (action, AllAlbumHomepageData data) =>
              _onTrackMore(action, null, data),
          onDownloadAlbum: (AllAlbumHomepageData data) =>
              _onDownloadAlbum(data),
          onDownloadPlaylist: (AllPlaylistsData data) =>
              _onDownloadPlaylist(data),
          onPlaylist: (AllPlaylistsData data) => _onPlaylist(data),
          onPlaylistMore: (action, AllPlaylistsData data) =>
              _onMorePopUp(action, data),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  Future<void> _onMorePopUp(dynamic action, AllPlaylistsData data) async {
    switch (action) {
      case 0:
        setState(() => _isLoading = true);
        String text =
            "${data.title!}, by ${data.user!.stageName ?? data.user!.name}";
        String imageUrl = data.media!.thumbnail!;

        String generatedLink = await _firebaseDynamicLink.createDynamicLink(
          albumId: null,
          albumUrlHash: null,
          singleMusicId: null,
          playlistid: data.id.toString(),
          bannerId: null,
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
            for (var content in data.content!)
              {
                "id": content.id.toString(),
                "title": content.title,
                "lyrics": null,
                "stageName": content.stageName,
                "filepath": content.filepath,
                "cover": content.cover,
                "thumb": content.cover,
                "thumbnail": content.thumbnail,
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
        _onDownloadPlaylist(data);
        break;
      case 3:
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
        break;
      default:
    }
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

  void _onDownloadAlbum(AllAlbumHomepageData data) {
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

  void _onPlaylist(AllPlaylistsData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaylistDetails(data),
      ),
    );
  }

  void _onAlbum(AllAlbumHomepageData data) {
    AllAlbumData albumData = AllAlbumData.fromJson(data.toJson());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allAlbumData: albumData,
          allMusicData: null,
        ),
      ),
    );
  }

  void _onMusic(MusicAllSongsData data, FavoriteContentModel model) {
    Map<String, dynamic> json = {
      "data": [
        for (String contentId in model.contentIdList!)
          if (contentId.substring(widget.contentType!.length) !=
                  data.id.toString() &&
              contentId.contains(widget.contentType!))
            _getSongDetails(contentId),
      ]
    };
    QueueModel queueModel = QueueModel.fromJson(json);

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

  Future<void> _onTrackMore(
    dynamic action,
    MusicAllSongsData? singleData,
    AllAlbumHomepageData? albumData,
  ) async {
    switch (action) {
      case 0:
        setState(() => _isLoading = true);
        String text = singleData != null
            ? "${singleData.title!} by ${singleData.stageName}"
            : "${albumData!.name!} by ${albumData.stageName}";

        String imageUrl = singleData != null
            ? singleData.media!.thumbnail!
            : albumData!.media!.thumbnail!;
        String generatedLink = await _firebaseDynamicLink.createDynamicLink(
          albumId: albumData != null ? albumData.id.toString() : null,
          albumUrlHash: albumData != null ? albumData.urlHash : null,
          singleMusicId: singleData != null ? singleData.id.toString() : null,
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
        String contentId = singleData != null
            ? singleData.id.toString()
            : albumData!.id.toString();
        String contentType = singleData != null ? "single" : "album";
        saveDeleteContentFavorite(
          contentId: contentId,
          state: () {
            setState(() => _isLoading = false);
          },
          type: contentType,
        );
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
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (content) => AddReport(
              albumId: albumData != null ? albumData.id.toString() : null,
              postId: singleData != null ? singleData.id.toString() : null,
              radioId: null,
            ),
          ),
        );
        break;
      default:
    }
  }

  Map<String, dynamic> _getSongDetails(String contentId) {
    AllMusicAllSongsModel songModel = allMusicAllSongsModel!;
    MusicAllSongsData? musicData;
    String id = contentId.substring(widget.contentType!.length);
    for (var data in songModel.data!) {
      if (data.id.toString() == id) {
        musicData = data;
        break;
      }
    }
    return {
      "id": musicData!.id,
      "title": musicData.title,
      "lyrics": musicData.lyrics,
      "stageName": musicData.stageName,
      "filepath": musicData.filepath,
      "cover": musicData.media!.normal,
      "thumb": musicData.media!.thumb,
      "thumbnail": musicData.media!.thumbnail,
      "isCoverLocal": false,
      "description": musicData.description,
      "artistId": musicData.userid,
    };
  }
}
