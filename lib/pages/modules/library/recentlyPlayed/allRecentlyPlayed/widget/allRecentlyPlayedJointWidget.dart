import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/playerModel.dart';
import 'package:rally/models/recentlyPlayedJointModel.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/homeRecentlyPlayed/widget/homeRecentlyAlbum.dart';
import 'package:rally/pages/modules/library/recentlyPlayed/recentlyPlayedJointDetails/recentlyPlayedJointDetails.dart';
import 'package:rally/providers/recentlyPlayedJointProvider.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/utils/musicPlayer/musicInitialize.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

class AllRecentlyPlayedJointWidget extends StatefulWidget {
  const AllRecentlyPlayedJointWidget({Key? key}) : super(key: key);

  @override
  State<AllRecentlyPlayedJointWidget> createState() =>
      _AllRecentlyPlayedJointWidgetState();
}

class _AllRecentlyPlayedJointWidgetState
    extends State<AllRecentlyPlayedJointWidget> {
  PaginatedItemsResponse<RecentlyPlayedJointData>? _postsResponse;

  PaginatedItemsResponse<RecentlyPlayedJointData>? get postsResponse =>
      _postsResponse;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recentlyPlayedJointStream,
      initialData: recentlyPlayedJointModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.data != null
              ? _mainContent(snapshot.data)
              : Container();
        } else if (snapshot.hasError) {
          return Container();
        }
        return shimmerItem(numOfItem: 4);
      },
    );
  }

  Widget _mainContent(RecentlyPlayedJointModel model) {
    _postsResponse = PaginatedItemsResponse<RecentlyPlayedJointData>(
      listItems: Iterable.castFrom(model.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );

    return PaginatedItemsBuilder<RecentlyPlayedJointData>(
      fetchPageData: (bool) async {
        _postsResponse = PaginatedItemsResponse<RecentlyPlayedJointData>(
          listItems: Iterable.castFrom(model.data!),
          // no support for pagination for current api
          paginationKey: null,
          idGetter: (post) => post.id.toString(),
        );
        return _postsResponse;
      },
      response: postsResponse,
      itemsDisplayType: ItemsDisplayType.grid,
      itemBuilder: (BuildContext context, int index, item) {
        return homeRecentlyAlbum(
          context: context,
          onAlbumPlayAll: () => _onJointPlayAll(item),
          onAlbumDetails: () => _onJointDetails(item),
          image: item.cover,
          title: item.title,
          width: 150,
          height: 150,
        );
      },
      loaderItemsCount: 15,
    );
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
}
