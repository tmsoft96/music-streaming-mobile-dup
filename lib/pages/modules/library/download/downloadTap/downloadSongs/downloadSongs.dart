import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/library/download/downloadOngoingPage/widget/downloadWidget.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allMusicAllSongsProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';
import 'package:rally/utils/videoPlayer/videoPlayer.dart';

class DownloadSongs extends StatefulWidget {
  final AllDownloadModel? model;

  DownloadSongs(this.model);

  @override
  State<DownloadSongs> createState() => _DownloadSongsState();
}

class _DownloadSongsState extends State<DownloadSongs> {
  PaginatedItemsResponse<AllDownloadData>? _postsResponse;

  PaginatedItemsResponse<AllDownloadData>? get postsResponse => _postsResponse;
  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();

  @override
  Widget build(BuildContext context) {
    _postsResponse = PaginatedItemsResponse<AllDownloadData>(
      listItems: Iterable.castFrom(widget.model!.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );
    return Scaffold(
      body: Stack(
        children: [
          downloadWidget(
            context: context,
            model: widget.model,
            onMusicMore: (AllDownloadData data, AllDownloadContent content) =>
                _onTrackMore(data, content),
            onMusicPlay: (AllDownloadData data, AllDownloadContent content) =>
                _onMusicPlay(data, content),
            fetchPageData: (bool) async {
              _postsResponse = PaginatedItemsResponse<AllDownloadData>(
                listItems: Iterable.castFrom(widget.model!.data!),
                // no support for pagination for current api
                paginationKey: null,
                idGetter: (post) => post.id.toString(),
              );
              return _postsResponse;
            },
            response: postsResponse,
            displayType: "songs",
          ),
          if (_isLoading)
            customLoadingPage(
              msg: _loadingMsg,
              percent: _loadingPercentage,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onMusicPlay(null, null),
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void _onTrackMore(AllDownloadData data, AllDownloadContent content) {
    setState(() => _isLoading = true);
    AllMusicAllSongsModel songModel = allMusicAllSongsModel!;
    MusicAllSongsData? musicData;
    for (var data in songModel.data!) {
      if (data.id.toString() == content.id) {
        musicData = data;
        break;
      }
    }
    setState(() => _isLoading = false);

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: content.cover,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: content.stageName,
          title: content.title,
          artistPicture: musicData!.user!.picture,
          onAddToPlaylist: () => _onAddToPlaylist(musicData!),
          onArtistProfile: () => _onArtistProfile(content),
          onFavorite: () => _onFavorite(musicData!),
          onMoreInfo: () => _onMusic(musicData!),
          onReport: () => _onReport(musicData!),
          onShare: () => _onShare(musicData!),
          onDownload: null,
          contentId: musicData.id.toString(),
          contentType: 'single',
        );
      },
    );
  }

  void _onMusic(MusicAllSongsData data) {
    Map<String, dynamic> json = {
      "data": [
        for (var model in widget.model!.data!)
          for (var content in model.content!)
            if (content.id != data.id.toString())
              {
                "id": content.id,
                "title": content.title,
                "lyrics": content.lyrics,
                "stageName": content.stageName,
                "filepath": content.localFilePath,
                "cover": content.cover,
                "thumbnail": content.thumbnail,
                "isCoverLocal": false,
                "description": content.description,
                "isQueue": false,
                "artistId": content.artistId,
                "isFileLocal": true,
              },
      ],
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

  void _onFavorite(MusicAllSongsData data) {
    setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id.toString(),
      state: () {
        setState(() => _isLoading = false);
      },
      type: "single",
    );
  }

  Future<void> _onShare(MusicAllSongsData data) async {
    setState(() => _isLoading = true);
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

    setState(() => _isLoading = false);
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

  void _onArtistProfile(AllDownloadContent content) {
    for (var data in allArtistsModel!.data!)
      if (content.artistId == data.userid) {
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

  void _onMusicPlay(AllDownloadData? data, AllDownloadContent? mainContent) {
    setState(() => _isLoading = true);
    Map<String, dynamic> json = {
      "data": [
        if (data != null && mainContent != null) ...[
          {
            "id": mainContent.id,
            "title": mainContent.title,
            "lyrics": mainContent.lyrics,
            "stageName": mainContent.stageName,
            "filepath": mainContent.localFilePath,
            "cover": mainContent.cover,
            "thumbnail": mainContent.thumbnail,
            "isCoverLocal": false,
            "description": mainContent.description,
            "artistId": mainContent.artistId,
            "isFileLocal": true,
          },
          for (var model in widget.model!.data!)
            for (var content in model.content!)
              if (mainContent.id != content.id && !content.isDownloading!)
                {
                  "id": content.id,
                  "title": content.title,
                  "lyrics": content.lyrics,
                  "stageName": content.stageName,
                  "filepath": content.localFilePath,
                  "cover": content.cover,
                  "thumbnail": content.thumbnail,
                  "isCoverLocal": false,
                  "description": content.description,
                  "isQueue": true,
                  "artistId": content.artistId,
                  "isFileLocal": true,
                },
        ],
        if (data == null)
          for (var model in widget.model!.data!)
            for (var content in model.content!)
              if (!content.isDownloading!)
                {
                  "id": content.id,
                  "title": content.title,
                  "lyrics": content.lyrics,
                  "stageName": content.stageName,
                  "filepath": content.localFilePath,
                  "cover": content.cover,
                  "thumbnail": content.thumbnail,
                  "isCoverLocal": false,
                  "description": content.description,
                  "isQueue": false,
                  "artistId": content.artistId,
                  "isFileLocal": true,
                },
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
