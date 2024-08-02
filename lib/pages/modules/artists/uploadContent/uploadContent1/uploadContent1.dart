import 'package:flutter/material.dart';
import 'package:rally/bloc/allGenreBloc.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allGenreModel.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent2/uploadContent2.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';

import 'widget/uploadContent1Widget.dart';

int selectedContent = 0;

class UploadContent1 extends StatefulWidget {
  final String? artistId, stageName;

  UploadContent1({this.artistId, this.stageName});

  @override
  State<UploadContent1> createState() => _UploadContent1State();
}

class _UploadContent1State extends State<UploadContent1> {
  AllGenreData? _allGenreData;
  List<Map<String, dynamic>> _contentTypeList = [
    {
      "image": SINGLES,
      "text": "Single",
      "selected": true,
    },
    {
      "image": ALBUM,
      "text": "Album or EP",
      "selected": false,
    }
  ];

  @override
  void initState() {
    super.initState();
    _onContentType(selectedContent);
    loadAllGenreMapOffline();
    allGenreBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Content")),
      body: StreamBuilder(
        stream: allGenreBloc.genre,
        initialData: allGenreMapOffline == null
            ? null
            : AllGenreModel.fromJson(
                json: allGenreMapOffline,
                httpMsg: "Offline Data",
              ),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ok)
              return _mainContent(snapshot.data);
            else
              return allGenreMapOffline == null
                  ? emptyBox(context, msg: "${snapshot.data.msg}")
                  : _mainContent(
                      AllGenreModel.fromJson(
                        json: allGenreMapOffline,
                        httpMsg: "Offline Data",
                      ),
                    );
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No data available");
          }
          return shimmerItem();
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: button(
          onPressed: () => _onContinue(),
          text: "Continue",
          color: PRIMARYCOLOR,
          context: context,
        ),
      ),
    );
  }

  Widget _mainContent(AllGenreModel model) {
    return uploadContent1Widget(
      contentTypeList: _contentTypeList,
      context: context,
      onContentType: (int index) => _onContentType(index),
      onGenre: (int index) => _onGenre(index, model),
      model: model,
    );
  }

  void _onGenre(int index, AllGenreModel model) {
    selectAllGenreData(model: model, index: index);
    _allGenreData = model.data![index];
    setState(() {});
  }

  void _onContinue() {
    if (_allGenreData == null) {
      toastContainer(text: "Select genre to continue", backgroundColor: RED);
      return;
    }
    Map<String, dynamic> meta = {
      "contentType": selectedContent,
      "genre": _allGenreData!.name,
      "genreId": _allGenreData!.id,
      "genreCover": _allGenreData!.cover,
      "artistId": widget.artistId ?? userModel!.data!.user!.userid,
      "stageName": widget.stageName ??
          userModel!.data!.user!.stageName ??
          userModel!.data!.user!.name,
    };
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadContent2(meta),
      ),
    );
  }

  void _onContentType(int index) {
    for (var data in _contentTypeList) data["selected"] = false;
    _contentTypeList[index]["selected"] = true;
    selectedContent = index;
    if (mounted) setState(() {});
  }
}
