import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rally/pages/modules/account/reportContent/addReport.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/recentPlayedDetail/widget/recentlyPlayedDetailsWidget.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/providers/recentlyPlayedSingleProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

class RecentlyPlayedDetails extends StatefulWidget {
  const RecentlyPlayedDetails({Key? key}) : super(key: key);

  @override
  State<RecentlyPlayedDetails> createState() => _RecentlyPlayedDetailsState();
}

class _RecentlyPlayedDetailsState extends State<RecentlyPlayedDetails> {
  PaginatedItemsResponse<RecentlyPlayedSingleData>? _postsResponse;

  PaginatedItemsResponse<RecentlyPlayedSingleData>? get postsResponse =>
      _postsResponse;

  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();
  bool _isLoading = false;
  String _loadingMsg = "";

  double? _loadingPercentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Last Played Songs")),
      body: StreamBuilder(
        stream: recentlyPlayedSingleStream,
        initialData: recentlyPlayedSingleModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _mainContent(snapshot.data);
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem();
        },
      ),
    );
  }

  Widget _mainContent(RecentlyPlayedSingleModel model) {
    _postsResponse = PaginatedItemsResponse<RecentlyPlayedSingleData>(
      listItems: Iterable.castFrom(model.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );

    return Stack(
      children: [
        recentlyPlayedDetailsWidget(
          context: context,
          fetchPageData: (bool) async {
            _postsResponse = PaginatedItemsResponse<RecentlyPlayedSingleData>(
              listItems: Iterable.castFrom(model.data!),
              // no support for pagination for current api
              paginationKey: null,
              idGetter: (post) => post.id.toString(),
            );
            return _postsResponse;
          },
          response: postsResponse,
          model: model,
          onMusic: (RecentlyPlayedSingleData data) => _onMusic(data, model),
          onMusicDownload: (RecentlyPlayedSingleData data) =>
              _onMusicDownload(data),
          onTrackMore: (action, RecentlyPlayedSingleData data) =>
              _onTrackMore(action, data),
          onPlayAll: () => _onPlayAll(model),
        ),
        if (_isLoading)
          customLoadingPage(
            msg: _loadingMsg,
            percent: _loadingPercentage,
          ),
      ],
    );
  }

  void _onMusicDownload(RecentlyPlayedSingleData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "single${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": data.stageName,
      "description": data.description,
      "createAt": DateTime.now().millisecondsSinceEpoch,
      "fileDownloaded": false,
      "content": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.cover,
          "thumbnail": data.thumbnail,
          "isCoverLocal": false,
          "description": data.description,
          "artistId": data.artistId,
          "downloaded": false,
          "localFile": null,
          "isDownloading": true,
        },
      ],
    };

    contentDownload(meta);
  }

  Future<void> _onTrackMore(
    dynamic action,
    RecentlyPlayedSingleData data,
  ) async {
    switch (action) {
      case 0:
        setState(() => _isLoading = true);
        String text = "${data.title!} by ${data.stageName}";

        String imageUrl = data.thumbnail!;
        String generatedLink = await _firebaseDynamicLink.createDynamicLink(
          albumId: null,
          albumUrlHash: null,
          singleMusicId: data.id,
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
        saveDeleteContentFavorite(
          contentId: data.id,
          state: () {
            setState(() => _isLoading = false);
          },
          type: "single",
        );
        break;
      case 2:
        Map<String, dynamic> json = {
          "data": [
            {
              "id": data.id,
              "title": data.title,
              "lyrics": data.lyrics,
              "stageName": data.stageName,
              "filepath": data.filepath,
              "cover": data.cover,
              "thumb": data.thumb,
              "thumbnail": data.thumbnail,
              "isCoverLocal": data.isCoverLocal,
              "description": data.description,
              "artistId": data.artistId,
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
        _onMusicDownload(data);
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (content) => AddReport(
              albumId: null,
              postId: data.id,
              radioId: null,
            ),
          ),
        );
        break;
      default:
    }
  }

  void _onMusic(
    RecentlyPlayedSingleData data,
    RecentlyPlayedSingleModel model,
  ) {
    Map<String, dynamic> json = {
      "data": [
        {
          "id": data.id,
          "title": data.title,
          "lyrics": data.lyrics,
          "stageName": data.stageName,
          "filepath": data.filepath,
          "cover": data.cover,
          "thumb": data.thumb,
          "thumbnail": data.thumbnail,
          "isCoverLocal": data.isCoverLocal,
          "description": data.description,
        },
        for (var modelData in model.data!)
          if (data.id != modelData.id.toString() &&
              data.title != modelData.title)
            {
              "id": modelData.id,
              "title": modelData.title,
              "lyrics": modelData.lyrics,
              "stageName": modelData.stageName,
              "filepath": modelData.filepath,
              "cover": modelData.cover,
              "thumb": modelData.thumb,
              "thumbnail": modelData.thumbnail,
              "isCoverLocal": modelData.isCoverLocal,
              "description": modelData.description,
              "isQueue": true,
            },
      ]
    };
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(json);
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

  Future<void> _onPlayAll(RecentlyPlayedSingleModel model) async {
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(model.toJson());
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
}
