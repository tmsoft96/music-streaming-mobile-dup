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
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allAlbumHomepageProvider.dart';
import 'package:rally/models/allAlbumHomepageModel.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/allTopAlbumFullWidget.dart';
import 'widget/allTopAlbumsWidget.dart';

class AllTopAlbums extends StatefulWidget {
  final int? noOfContentDisplay;

  AllTopAlbums({this.noOfContentDisplay});

  @override
  State<AllTopAlbums> createState() => _AllTopAlbumsState();
}

class _AllTopAlbumsState extends State<AllTopAlbums> {
  PaginatedItemsResponse<AllAlbumHomepageData>? _postsResponse;

  PaginatedItemsResponse<AllAlbumHomepageData>? get postsResponse =>
      _postsResponse;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allAlbumHomepageModelStream,
      initialData: allAlbumHomepageModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return allAlbumHomepageModel!.data == null
                ? widget.noOfContentDisplay == -1000
                    ? emptyBox(context, msg: "${snapshot.data.msg}")
                    : emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allAlbumHomepageModel!);
        } else if (snapshot.hasError) {
          return widget.noOfContentDisplay == -1000
              ? emptyBox(context, msg: "No data available")
              : emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem();
      },
    );
  }

  Widget _mainContent(AllAlbumHomepageModel model) {
    _postsResponse = PaginatedItemsResponse<AllAlbumHomepageData>(
      listItems: Iterable.castFrom(model.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );
    return widget.noOfContentDisplay == -1000
        ? allTopAlbumFullWidget(
            context: context,
            model: model,
            onAlbum: (AllAlbumHomepageData data) => _onAlbum(data),
            fetchPageData: (bool) async {
              _postsResponse = PaginatedItemsResponse<AllAlbumHomepageData>(
                listItems: Iterable.castFrom(model.data!),
                // no support for pagination for current api
                paginationKey: null,
                idGetter: (post) => post.id.toString(),
              );
              return _postsResponse;
            },
            response: postsResponse,
            onAlbumMore: (AllAlbumHomepageData data) => _onTrackMore(data),
            onPlayAlbum: (AllAlbumHomepageData data) => _onPlayAlbum(data),
          )
        : allTopAlbumsWidget(
            context: context,
            onSeeAll: () => _onSeeAll(),
            onAlbum: (AllAlbumHomepageData data) => _onAlbum(data),
            model: model,
            onAlbumMore: (AllAlbumHomepageData data) => _onTrackMore(data),
            onPlayAlbum: (AllAlbumHomepageData data) => _onPlayAlbum(data),
          );
  }

  void _onPlayAlbum(AllAlbumHomepageData data) {
    Map<String, dynamic> json = {
      "data": [
        for (var file in data.files!)
          {
            "id": data.id,
            "title": file.name,
            "lyrics": file.lyrics,
            "stageName": data.stageName,
            "filepath": file.filepath,
            "cover": data.media!.thumb,
            "thumb": data.media!.thumb,
            "thumbnail": data.media!.thumbnail,
            "isCoverLocal": false,
            "description": data.description,
            "artistId": data.userid,
          },
      ]
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

  void _onTrackMore(AllAlbumHomepageData data) {
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
          onMoreInfo: () => _onAlbum(data),
          onReport: () => _onReport(data),
          onShare: () => _onShare(data),
          onDownload: () => _onDownloadAlbum(data),
          contentId: data.id.toString(),
          contentType: "album",
        );
      },
    );
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

  void _onFavorite(AllAlbumHomepageData data) {
    // setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        // setState(() => _isLoading = false);
      },
      type: "album",
    );
  }

  Future<void> _onShare(AllAlbumHomepageData data) async {
    toastContainer(text: "Please wait", backgroundColor: GREEN);
    String text = "${data.name!} by ${data.stageName}";

    String imageUrl = data.media!.thumbnail!;
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

  void _onReport(AllAlbumHomepageData data) {
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

  void _onArtistProfile(AllAlbumHomepageData albumData) {
    for (var data in allArtistsModel!.data!)
      if (albumData.userid == data.userid) {
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

  void _onAddToPlaylist(AllAlbumHomepageData data) {
    Map<String, dynamic> json = {
      "data": [
        for (var file in data.files!)
          {
            "id": file.id,
            "title": file.name,
            "lyrics": file.lyrics,
            "stageName": data.stageName,
            "filepath": file.filepath,
            "cover": data.media!.normal,
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
          appBar: AppBar(title: Text("Top Album")),
          body: AllTopAlbums(noOfContentDisplay: -1000),
        ),
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
}
