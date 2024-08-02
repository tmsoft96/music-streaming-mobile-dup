import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/trackMoreWidget.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allMusicProvider.dart';

import 'widget/allMusicVideosWidget.dart';
import 'widget/artistMusicVideoFullWidget.dart';

class AllMusicVideos extends StatefulWidget {
  final int? noOfContentDisplay;

  AllMusicVideos({this.noOfContentDisplay});

  @override
  State<AllMusicVideos> createState() => _AllMusicVideosState();
}

class _AllMusicVideosState extends State<AllMusicVideos> {
  AllMusicProvider _provider = AllMusicProvider();

  @override
  void initState() {
    super.initState();
    _provider.get(isLoad: false, filterArtistId: null);
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
        return shimmerItem(useGrid: true);
      },
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return widget.noOfContentDisplay == -1000
        ? artistMusicVideoFullWidget(
            context: context,
            onMusic: (AllMusicData data) => _onMusic(data),
            model: model,
            pageFetch: (int offset, AllMusicModel model) =>
                _pageFetch(offset, model),
            onContentMore: (AllMusicData data) => _onTrackMore(data),
            onContentPlay: (AllMusicData data) {},
          )
        : allMusicVideosWidget(
            context: context,
            onSeeAll: () => _onSeeAll(),
            model: model,
            onMusic: (AllMusicData data) => _onMusic(data),
            onTrackMore: (AllMusicData data) => _onTrackMore(data),
            // TODO: WORK HERE VIDEO
            onPlayTrack: (AllMusicData data) {},
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

  int _loadEachItem = 20;
  int _totalDataCount = 0;
  int _currentDataCount = 0;
  Future<List<AllMusicData>> _pageFetch(int offset, AllMusicModel model) async {
    _totalDataCount = model.data!.length;
    _currentDataCount = offset == 0
        ? _totalDataCount > _loadEachItem
            ? _loadEachItem
            : _totalDataCount
        : (_currentDataCount + _loadEachItem) > _totalDataCount
            ? _totalDataCount
            : _currentDataCount + _loadEachItem;

    List<AllMusicData> dataList = [];
    for (int x = offset; x < _currentDataCount; ++x)
      if (model.data![x].filepath!.split("/").last.contains("mp4"))
        dataList.add(model.data![x]);

    final List<AllMusicData> nextUsersList = List.generate(
      dataList.length,
      (int index) => AllMusicData(
        id: dataList[index].id,
        userid: dataList[index].userid,
        comments: dataList[index].comments,
        cover: dataList[index].cover,
        streams: dataList[index].streams,
        title: dataList[index].title!,
        createdAt: dataList[index].createdAt,
        currentListenerRate: dataList[index].currentListenerRate,
        deletedAt: dataList[index].deletedAt,
        description: dataList[index].description,
        downloads: dataList[index].downloads,
        filepath: dataList[index].filepath,
        fiveRate: dataList[index].fiveRate,
        fourRate: dataList[index].fourRate,
        genres: dataList[index].genres,
        likes: dataList[index].likes,
        lyrics: dataList[index].lyrics,
        media: dataList[index].media,
        oneRate: dataList[index].oneRate,
        public: dataList[index].public,
        ratings: dataList[index].ratings,
        stageName: dataList[index].stageName,
        tags: dataList[index].tags,
        threeRate: dataList[index].threeRate,
        totalRate: dataList[index].totalRate,
        twoRate: dataList[index].twoRate,
        type: dataList[index].type,
        updatedAt: dataList[index].updatedAt,
        user: dataList[index].user,
      ),
    );

    if (_totalDataCount - 1 == _currentDataCount)
      _currentDataCount =
          _totalDataCount > _loadEachItem ? _loadEachItem : _totalDataCount;

    await Future.delayed(Duration(seconds: 1));
    return nextUsersList;
  }

  void _onSeeAll() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("Music Videos")),
          body: AllMusicVideos(noOfContentDisplay: -1000),
        ),
      ),
    );
  }

  void _onMusic(AllMusicData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlbumsDetailsPage(
          allAlbumData: null,
          allMusicData: data,
        ),
      ),
    );
  }
}
