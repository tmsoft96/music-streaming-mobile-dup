import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allMusicProvider.dart';

import 'widget/homeArtistVideoContentWidget.dart';

class HomeArtistVideoContent extends StatefulWidget {
  final int? noOfContentDisplay;
  final String? artistId;

  HomeArtistVideoContent({
    this.noOfContentDisplay,
    @required this.artistId,
  });

  @override
  State<HomeArtistVideoContent> createState() => _HomeArtistVideoContentState();
}

class _HomeArtistVideoContentState extends State<HomeArtistVideoContent> {
  AllMusicProvider _provider = AllMusicProvider();

  @override
  void initState() {
    super.initState();
    _provider.get(
        isLoad: false,
        filterArtistId: widget.artistId ?? userModel!.data!.user!.userid!);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allMusicModelStream,
      initialData: allMusicModel ?? null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return allMusicModel == null
                ? widget.noOfContentDisplay == -1000
                    ? emptyBox(context, msg: "${snapshot.data.msg}")
                    : emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allMusicModel!);
        } else if (snapshot.hasError) {
          return widget.noOfContentDisplay == -1000
              ? emptyBox(context, msg: "No data available")
              : emptyBoxLinear(context, msg: "No data available");
        }
        return widget.noOfContentDisplay == 1
            ? shimmerItem(numOfItem: 1)
            : shimmerItem();
      },
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return homeArtistVideoContentWidget(
      context: context,
      noOfContentDisplay: widget.noOfContentDisplay,
      model: model,
      onContent: (AllMusicData data) => _onContent(data),
      onContentMore: (AllMusicData data) => _onTrackMore(data),
      // TODO: WORK HERE VIDEO
      onContentPlay: (AllMusicData data) {},
    );
  }

  void _onTrackMore(AllMusicData data) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        // TODO: WORK HERE VIDEO
        return trackMoreWidget(
          context: context,
          contentImage: data.media!.thumb,
          onClose: () => navigation(context: context, pageName: "back"),
          artistName: data.stageName,
          title: data.title,
          artistPicture: data.user!.picture,
          onAddToPlaylist: () {},
          onArtistProfile: () {},
          onFavorite: () {},
          onMoreInfo: () {},
          onReport: () {},
          onShare: () {},
          onDownload: () {},
          contentId: data.id.toString(),
          contentType: 'video',
        );
      },
    );
  }

  void _onContent(AllMusicData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allMusicData: data,
          allAlbumData: null,
        ),
      ),
    );
  }
}
