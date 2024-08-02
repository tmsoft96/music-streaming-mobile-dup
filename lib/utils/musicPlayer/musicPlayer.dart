import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/pages/modules/artists/allContents/allContentsPage.dart';
import 'package:rally/pages/modules/music/commentSection/commentSection.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/providers/allArtistsProvider.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rxdart/rxdart.dart';
// ignore: unused_import
import 'package:audio_session/audio_session.dart';

import 'widget/common.dart';
import 'musicInitialize.dart';
import 'widget/audioPlayerOverlayWidget.dart';
import 'widget/audioPlayerWidget.dart';

double? bottomValue;
OverlayEntry? _entry;

void onHideOverlay() {
  _entry?.remove();
  _entry = null;
}

class MusicPlayer extends StatefulWidget {
  final PlayerModel? playerModel;
  final bool? isRadio;

  MusicPlayer({
    @required this.playerModel,
    this.isRadio = false,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool _isSinglePlayer = true,
      _isLoading = false,
      _getBottomPositionValueOnce = true;
  String _loadingMsg = "";
  double? _loadingPercentage;
  int _displayType = 2;

  Offset _offset = Offset(20, bottomValue ?? 50);

  @override
  void initState() {
    super.initState();

    onHideOverlay();

    // checking player to display
    // int realData = 0;
    // for (int x = 0; x < widget.playerModel!.data!.length; ++x)
    //   if (!widget.playerModel!.data![x].isQueue!) ++realData;
    // _isSinglePlayer = realData == 1;

    player!.play();
  }

  @override
  void dispose() {
    // _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player!.positionStream,
          player!.bufferedPositionStream,
          player!.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    if (_getBottomPositionValueOnce) {
      bottomValue = MediaQuery.of(context).size.height * .8;
      _getBottomPositionValueOnce = false;
    }

    return WillPopScope(
      onWillPop: () async {
        _onClosePlayer();
        return false;
      },
      child: SafeArea(
        child: SwipeDetector(
          onSwipeDown: (offset) => _onClosePlayer(),
          child: Stack(
            children: [
              audioPlayerWidget(
                context: context,
                onSinglePlayer: () => _onSinglePlayer(),
                isSinglePlayer: _isSinglePlayer,
                onDownload: () => _onDownload(),
                isRadio: widget.isRadio,
                onClose: () => _onClosePlayer(),
                onDisplayType: (int displayType) => _onDisplayType(displayType),
                onPlaylistAdd: () => _onPlaylistAdd(),
                displayType: _displayType,
                player: player,
                positionDataStream: _positionDataStream,
                playlist: playlist,
                onComment: () => _onComment(),
                onFavorite: () => _onFavorite(),
                onArtist: () => _onArtist(),
                playerModel: widget.playerModel,
              ),
              if (_isLoading)
                customLoadingPage(
                  msg: _loadingMsg,
                  percent: _loadingPercentage,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDownload() async {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    PlayerData data = currentMediaItem != null
        ? widget.playerModel!.data![int.parse(currentMediaItem!.id)]
        : widget.playerModel!.data![0];

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

  Future<void> _onArtist() async {
    String artistId = currentMediaItem != null
        ? widget.playerModel!.data![int.parse(currentMediaItem!.id)].artistId!
        : widget.playerModel!.data![0].artistId!;
    for (var data in allArtistsModel!.data!)
      if (artistId == data.userid) {
        _onShowOverlay();
        await Navigator.of(context).push(
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
        onHideOverlay();
        break;
      }
  }

  void _onFavorite() {
    setState(() => _isLoading = true);
    String contentId = currentMediaItem != null
        ? widget.playerModel!.data![int.parse(currentMediaItem!.id)].id!
        : widget.playerModel!.data![0].id!;
    saveDeleteContentFavorite(
      contentId: contentId,
      state: () {
        setState(() => _isLoading = false);
      },
      type: "single",
    );
  }

  void _onComment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommentSection(
          contentId:
              widget.playerModel!.data![int.parse(currentMediaItem!.id)].id,
        ),
      ),
    );
  }

  void _onOverlayShowPage(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: false,
      backgroundColor: TRANSPARENT,
      builder: (context) => MusicPlayer(
        playerModel: widget.playerModel,
        isRadio: widget.isRadio,
      ),
    );
  }

  void _onShowOverlay() {
    _entry = OverlayEntry(
      builder: (context) => audioPlayerOverlayWidget(
        context: context,
        offset: _offset,
        onPanUpdate: (DragUpdateDetails details) {
          _offset += details.delta;
          _entry!.markNeedsBuild();
        },
        onPlayOrPause: () {
          player!.playing ? player!.pause() : player!.play();
          _entry!.markNeedsBuild();
        },
        onClose: () => _onCloseOverlay(),
        isPlaying: player!.playing,
        onTap: () => _onOverlayShowPage(context),
        player: player,
      ),
    );
    final overlay = Overlay.of(context)!;
    overlay.insert(_entry!);
  }

  void _onCloseOverlay() {
    onHideOverlay();
    player!.dispose();
  }

  void _onClosePlayer() {
    navigation(context: context, pageName: "back");
    _onShowOverlay();
  }

  Future<void> _onPlaylistAdd() async {
    _onShowOverlay();
    Map<String, dynamic> json = {
      "data": [
        currentMediaItem != null
            ? widget.playerModel!.data![int.parse(currentMediaItem!.id)]
                .toJson()
            : widget.playerModel!.data![0].toJson()
      ]
    };
    PlayerModel playerModel = PlayerModel.fromJson(json);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePlaylists(
          playerModel: playerModel,
        ),
      ),
    );
    onHideOverlay();
  }

  void _onDisplayType(int displayType) {
    setState(() {
      _displayType = displayType;
    });
  }

  void _onSinglePlayer() {
    setState(() {
      _isSinglePlayer = !_isSinglePlayer;
    });
  }

  // Future<void> _onDownload() async {
  //   setState(() => _isLoading = true);

  //   if (currentMediaItem == null) {
  //     toastContainer(
  //       text: "Play content first to enable download",
  //       backgroundColor: RED,
  //     );
  //     return;
  //   }

  //   // checking if file exits
  //   int? localId;
  //   await getAllDownload().then((DownloadsModelList value) {
  //     for (var data in value.downloadsModelList!) {
  //       if (data.contentId == currentMediaItem!.extras!["playerData"]) {
  //         localId = data.id;
  //         break;
  //       }
  //     }
  //   });

  //   if (localId != null) {
  //     print("same data exits");
  //     DownloadsCrud crud = new DownloadsCrud();
  //     await crud.deleteItem(localId!);
  //   }

  //   List<Map<String, dynamic>>? contentList = [];
  //   String? artistId, artistStageName, cover, description, title, contentId;
  //   String fileUrl = currentMediaItem!.extras!["filepath"];
  //   String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
  //   String filePath = await getFilePath(fileName);
  //   // _downloadingFilePath = filePath;
  //   await downloadFile(
  //     fileUrl,
  //     filePath: filePath,
  //     onProgress: (int rec, int total, String percentCompletedText,
  //         double percentCompleteValue) {
  //       print("$rec $total");
  //       // _isCompleteDownload = false;
  //       // print(_isCompleteDownload);
  //       setState(() {
  //         _loadingMsg = percentCompletedText;
  //         _loadingPercentage = percentCompleteValue;
  //       });
  //     },
  //     onDownloadComplete: (String? savePath) async {
  //       // _isCompleteDownload = true;
  //       // print(_isCompleteDownload);
  //     },
  //   );
  //   contentList.add({
  //     "contentLink": fileUrl,
  //     "contentLocalPath": filePath,
  //     "contentUserId": "",
  //     "cover": currentMediaItem!.artUri.toString(),
  //     "description": widget
  //         .playerModel!.data![int.parse(currentMediaItem!.id)].description,
  //     "id": currentMediaItem!.extras!["contentId"],
  //     "lyrics": currentMediaItem!.extras!["lyrics"],
  //     "title": currentMediaItem!.title,
  //   });
  //   artistId = "";
  //   artistStageName = currentMediaItem!.artist;
  //   cover = currentMediaItem!.artUri.toString();
  //   description = currentMediaItem!.extras!["description"];
  //   title = currentMediaItem!.title;
  //   contentId = currentMediaItem!.extras!["contentId"];

  //   await submitDownloads(
  //     artistId: artistId,
  //     artistStageName: artistStageName,
  //     contentListEncode: json.encode(contentList),
  //     cover: cover,
  //     description: description,
  //     title: title,
  //     contentId: contentId,
  //   ).then((value) {
  //     setState(() => _isLoading = false);
  //     toastContainer(
  //       text: "${value["msg"]}",
  //       backgroundColor: value['ok'] ? GREEN : RED,
  //     );
  //   });
  // }

}
