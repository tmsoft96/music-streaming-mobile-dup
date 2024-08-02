import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/recentlyPlayedJointModel.dart';
import 'package:rally/pages/modules/library/playlists/createPlaylists/createPlaylists.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/recentlyPlayedJointDetailsWidget.dart';

class RecentlyPlayedJointDetails extends StatefulWidget {
  final RecentlyPlayedJointData? data;

  RecentlyPlayedJointDetails(this.data);

  @override
  State<RecentlyPlayedJointDetails> createState() =>
      _RecentlyPlayedJointDetailsState();
}

class _RecentlyPlayedJointDetailsState
    extends State<RecentlyPlayedJointDetails> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          recentlyPlayedJointDetailsWidget(
            context: context,
            onBack: () => navigation(context: context, pageName: "back"),
            onMorePopUp: () => _onTrackMore(widget.data!),
            onReadMore: () => _onReadMore(),
            onMusic: (RecentlyPlayedContent content) => _onPlay(content),
            onPlayAll: () => _onPlay(null),
            onDownloadAll: () => _onDownloadJoint(widget.data!),
            onFavorite: () => _onFavorite(widget.data!),
            data: widget.data,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  void _onTrackMore(RecentlyPlayedJointData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return trackMoreWidget(
          context: context,
          contentImage: data.cover,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.artistName,
          title: data.title,
          artistPicture: data.cover,
          onAddToPlaylist: () => _onAddToPlaylist(data),
          onArtistProfile: null,
          onFavorite: () => _onFavorite(data),
          onMoreInfo: () => _onReadMore(),

          onReport: null,
          onShare: null,
          onDownload: () => _onDownloadJoint(data),
          contentId: data.id,
          contentType: data.contentType,
        );
      },
    );
  }

    void _onDownloadJoint(RecentlyPlayedJointData data) {
    if (ongoingDownload) {
      toastContainer(
        text: "Download on going please wait for it to finish",
        backgroundColor: RED,
      );
      return;
    }

    Map<dynamic, dynamic> meta = {
      "id": "${data.contentType}${data.id}",
      "cover": data.cover,
      "title": data.title,
      "artistName": data.artistName,
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
            "thumbnail": content.thumbnail,
            "isCoverLocal": false,
            "description": content.description,
            "artistId": content.artistId,
            "downloaded": false,
            "localFile": null,
            "isDownloading": true,
          },
      ],
    };

    contentDownload(meta);
  }


  void _onAddToPlaylist(RecentlyPlayedJointData data) {
    Map<String, dynamic> json = {
      "data": [
        for (var file in data.content!)
          {
            "id": file.id,
            "title": file.title,
            "lyrics": file.lyrics,
            "stageName": file.stageName,
            "filepath": file.filepath,
            "cover": file.cover,
            "thumb": file.cover,
            "thumbnail": file.thumbnail,
            "isCoverLocal": false,
            "description": file.description,
            "artistId": file.artistId,
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

  void _onFavorite(RecentlyPlayedJointData data) {
    setState(() => _isLoading = true);
    saveDeleteContentFavorite(
      contentId: data.id,
      state: () {
        setState(() => _isLoading = false);
      },
      type: data.contentType,
    );
  }

  Future<void> _onPlay(RecentlyPlayedContent? content) async {
    setState(() => _isLoading = true);

    Map<String, dynamic> json = {
      "data": [
        if (content != null)
          {
            "id": content.id,
            "title": content.title,
            "lyrics": content.lyrics,
            "stageName": content.stageName,
            "filepath": content.filepath,
            "cover": content.cover,
            "thumbnail": content.thumbnail,
            "isCoverLocal": false,
            "description": content.description,
            "artistId": content.artistId,
          },
        for (var data in widget.data!.content!)
          if (data.id != content!.id)
            {
              "id": data.id,
              "title": data.title,
              "lyrics": data.lyrics,
              "stageName": data.stageName,
              "filepath": data.filepath,
              "cover": data.cover,
              "thumbnail": data.thumbnail,
              "isCoverLocal": data.isCoverLocal,
              "description": data.description,
              "artistId": data.artistId,
            },
      ],
    };
    onHideOverlay();
    PlayerModel playerModel = PlayerModel.fromJson(json);
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

  void _onReadMore() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          color: BLACK,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title", style: h5BlackBold),
                SizedBox(height: 10),
                Text(
                  "${widget.data!.title!} - (${widget.data!.content!.length} songs)",
                  style: h5Black,
                ),
                SizedBox(height: 20),
                Text("Description", style: h5BlackBold),
                SizedBox(height: 10),
                Text(
                  "${widget.data!.description!}",
                  style: h5Black,
                ),
                SizedBox(height: 20),
                Text("Created By", style: h5BlackBold),
                SizedBox(height: 10),
                Text(
                  "${widget.data!.artistName}",
                  style: h5Black,
                ),
                SizedBox(height: 20),
                Text("Release Date", style: h5BlackBold),
                SizedBox(height: 10),
                Text(
                  "${getReaderDate(widget.data!.createAt!)}",
                  style: h5Black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
