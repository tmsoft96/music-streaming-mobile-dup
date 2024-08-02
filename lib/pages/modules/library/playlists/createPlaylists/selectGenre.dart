import 'package:flutter/material.dart';
import 'package:rally/bloc/allGenreBloc.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/offlineData.dart';
import 'package:rally/models/allGenreModel.dart';

import 'widget/selectGenreWidget.dart';

class SelectGenre extends StatefulWidget {
  @override
  State<SelectGenre> createState() => _SelectGenreState();
}

class _SelectGenreState extends State<SelectGenre> {
  AllGenreData? _allGenreData;

  @override
  void initState() {
    super.initState();
    loadAllGenreMapOffline();
    allGenreBloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Genre")),
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
    );
  }

  Widget _mainContent(AllGenreModel model) {
    return selectGenreWidget(
      context: context,
      onGenre: (int index) => _onGenre(index, model),
      model: model,
    );
  }

  void _onGenre(int index, AllGenreModel model) {
    selectAllGenreData(model: model, index: index);
    _allGenreData = model.data![index];
    setState(() {});
    Navigator.pop(context, _allGenreData);
  }
}
