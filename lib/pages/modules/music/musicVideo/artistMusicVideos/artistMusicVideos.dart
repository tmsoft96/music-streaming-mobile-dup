import 'package:flutter/material.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/artists/artistContent/allArtistContent/allArtistContent.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allMusicProvider.dart';

import 'widget/artistMusicVideosWidget.dart';

class ArtistMusicVideos extends StatefulWidget {
  final String? artistId, artistName;

  ArtistMusicVideos({
    @required this.artistId,
    @required this.artistName,
  });
  @override
  State<ArtistMusicVideos> createState() => _ArtistMusicVideosState();
}

class _ArtistMusicVideosState extends State<ArtistMusicVideos> {
  String _artistName = "";
  AllMusicProvider _provider = AllMusicProvider();

  @override
  void initState() {
    super.initState();
    if (widget.artistName!.contains("ft"))
      _artistName = widget.artistName!.split("ft")[0];
    else
      _artistName = widget.artistName!;
    super.initState();
    _provider.get(isLoad: false, filterArtistId: widget.artistId);
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
                ? emptyBoxLinear(context, msg: "${snapshot.data.msg}")
                : _mainContent(allMusicModel!);
        } else if (snapshot.hasError) {
          return emptyBoxLinear(context, msg: "No data available");
        }
        return shimmerItem();
      },
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return artistMusicVideosWidget(
      context: context,
      onSeeAll: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AllArtistContent(
            artistId: widget.artistId,
          ),
        ),
      ),
      onContent: (AllMusicData data) => _onContent(data),
      artistName: _artistName,
      model: model,
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
