import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/queueModel.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allAlbumProvider.dart';
import 'package:rally/providers/allMusicAllSongsProvider.dart';

import 'widget/musicWidget.dart';

class MusicPage extends StatefulWidget {
  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  Stream<String>? _selectedGenreStream = Stream.value("all");
  String _genreDisplay = "all";

  bool _isLoading = false, _isRouteOnce = false;

  AllAlbumModel? _allAlbumModel;

  @override
  void initState() {
    super.initState();
    _isRouteOnce = true;
    _selectedGenreStream = Stream.value("all");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: allMusicAllSongsModelStream,
            initialData: allMusicAllSongsModel ?? null,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.ok)
                  return _mainContent(snapshot.data);
                else
                  return allMusicAllSongsModel == null
                      ? _mainContent(null)
                      : _mainContent(allMusicAllSongsModel);
              } else if (snapshot.hasError) {
                return _mainContent(null);
              }
              return _mainContent(null);
            },
          ),
          if (deepLinkAlbumIdStream != null)
            StreamBuilder(
              stream: deepLinkAlbumIdStream,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _onAlbumDeepLink(snapshot.data.toString());
                  });
                return customLoadingPage();
              },
            ),
        ],
      ),
    );
  }

  Widget _mainContent(AllMusicAllSongsModel? model) {
    return Stack(
      children: [
        if (deepLinkSongIdStream == null) _musicWidget(model),
        if (deepLinkSongIdStream != null)
          StreamBuilder(
            stream: deepLinkSongIdStream,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onSongDeepLink(model, snapshot.data.toString());
                });
              return _musicWidget(model);
            },
          ),
        if (_isLoading) customLoadingPage(),
      ],
    );
  }

  Widget _musicWidget(AllMusicAllSongsModel? model) {
    return RefreshIndicator(
      onRefresh: () => loadHomepageFiles(),
      child: musicWidget(
        allMusicAllSongsModel: model,
        onGenre: (String genre) => _onGenre(genre),
        genreDisplay: _genreDisplay,
        selectedGenreStream: _selectedGenreStream,
      ),
    );
  }

  Future<void> _onAlbumDeepLink(String deepLinkAlbumId) async {
    if (_isRouteOnce) {
      _isRouteOnce = false;

      AllAlbumProvider provider = new AllAlbumProvider();
      _allAlbumModel = await provider.fetch("0", null);

      for (var data in _allAlbumModel!.data!) {
        int deepId = int.parse(deepLinkAlbumId);
        if (data.id == deepId) {
          deepLinkAlbumIdStream = null;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumsDetailsPage(
                allAlbumData: data,
                allMusicData: null,
              ),
            ),
          );
          break;
        }
      }
    }
  }

  void _onSongDeepLink(AllMusicAllSongsModel? model, String deepLinkSongId) {
    if (model != null && _isRouteOnce) {
      _isRouteOnce = false;
      for (var data in model.data!) {
        int deepId = int.parse(deepLinkSongId);
        if (data.id! == deepId) {
          Map<String, dynamic> json = {
            "data": [
              for (int x = 0;
                  x < (model.data!.length > 30 ? 30 : model.data!.length);
                  ++x)
                {
                  "id": model.data![x].id,
                  "title": model.data![x].title,
                  "lyrics": model.data![x].lyrics,
                  "stageName": model.data![x].stageName,
                  "filepath": model.data![x].filepath,
                  "cover": model.data![x].media!.normal,
                  "thumb": model.data![x].media!.thumb,
                  "thumbnail": model.data![x].media!.thumbnail,
                  "isCoverLocal": false,
                  "description": model.data![x].description,
                  "isQueue": true,
                },
            ],
          };
          QueueModel queueModel = QueueModel.fromJson(json);

          deepLinkSongIdStream = null;

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

          break;
        }
      }
    }
  }

  void _onGenre(String genre) {
    _genreDisplay = genre;
    _selectedGenreStream = Stream.value(genre);
    setState(() {});
  }
}
