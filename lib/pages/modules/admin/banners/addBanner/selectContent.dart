import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/pages/modules/music/album/albumsDetails/albumsDetailsPage.dart';
import 'package:rally/providers/allMusicProvider.dart';
import 'package:rally/spec/styles.dart';

import 'widget/selectContentWidget.dart';

class SelectContent extends StatefulWidget {
  @override
  State<SelectContent> createState() => _SelectContentState();
}

class _SelectContentState extends State<SelectContent> {
  int _tapIndex = 0;

  AllMusicProvider _provider = AllMusicProvider();

  @override
  void initState() {
    super.initState();
    _provider.get(isLoad: false, filterArtistId: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Content")),
      body: StreamBuilder(
        stream: allMusicModelStream,
        initialData: allMusicModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allMusicModel == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(allMusicModel!);
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem(useGrid: true);
        },
      ),
    );
  }

  Widget _mainContent(AllMusicModel model) {
    return selectContentWidget(
      context: context,
      onMusic: (AllMusicData data) => _onSong(data),
      model: model,
      onTap: (int index) {
        setState(() {
          _tapIndex = index;
        });
      },
      tapIndex: _tapIndex,
    );
  }

  Future<void> _onSong(AllMusicData data) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, data);
                },
                child: Text('Select Content', style: h4BlackBold),
              ),
              Divider(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AlbumsDetailsPage(
                        allAlbumData: null,
                        allMusicData: data,
                      ),
                    ),
                  );
                },
                child: Text('Listen to content', style: h4BlackBold),
              ),
            ],
          );
        });
  }
}
