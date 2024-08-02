import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/recentlyPlayedJointModel.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/recentlyPlayedJointDetails/recentlyPlayedJointDetails.dart';
import 'package:rally/providers/recentlyPlayedSingleProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import 'widget/homeRecentlyWidget.dart';

class HomeRecentlyPlayed extends StatefulWidget {
  const HomeRecentlyPlayed({Key? key}) : super(key: key);

  @override
  State<HomeRecentlyPlayed> createState() => _HomeRecentlyPlayedState();
}

class _HomeRecentlyPlayedState extends State<HomeRecentlyPlayed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: StreamBuilder(
        stream: recentlyPlayedSingleStream,
        initialData: recentlyPlayedSingleModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _mainContent(snapshot.data);
          } else if (snapshot.hasError) {
            return Container();
          }
          return shimmerItem(numOfItem: 1);
        },
      ),
    );
  }

  Widget _mainContent(RecentlyPlayedSingleModel model) {
    return model.data != null && model.data!.length > 0
        ? homeRecentlyPlayedWidget(
            context: context,
            onViewAllSongs: () => navigation(
              context: context,
              pageName: 'recentlyplayeddetails',
            ),
            onTrack: (RecentlyPlayedSingleData data) => _onMusic(data, model),
            onPlayAll: () => _onPlayAll(model),
            onSeeAll: () =>
                navigation(context: context, pageName: "allrecentlyplayed"),
            model: model,
            onJointDetails: (RecentlyPlayedJointData details) =>
                _onJointDetails(details),
            onJointPlayAll: (RecentlyPlayedJointData details) =>
                _onJointPlayAll(details),
          )
        : Container();
  }

  void _onJointDetails(RecentlyPlayedJointData details) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecentlyPlayedJointDetails(details),
      ),
    );
  }

  void _onJointPlayAll(RecentlyPlayedJointData details) {
    Map<String, dynamic> json = {
      "data": [
        for (var modelData in details.content!)
          {
            "id": modelData.id,
            "title": modelData.title,
            "lyrics": modelData.lyrics,
            "stageName": modelData.stageName,
            "filepath": modelData.filepath,
            "cover": modelData.cover,
            "thumb": modelData.cover,
            "thumbnail": modelData.thumbnail,
            "isCoverLocal": modelData.isCoverLocal,
            "description": modelData.description,
            "artistId": modelData.artistId,
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
              "thumbnail": data.thumbnail,
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
