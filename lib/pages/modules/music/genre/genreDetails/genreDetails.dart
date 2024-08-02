import 'package:flutter/material.dart';
import 'package:rally/models/allMusicAllSongsModel.dart';
import 'package:rally/models/allMusicModel.dart';

import 'widget/genreDetailsWidget.dart';

class GenreDetails extends StatefulWidget {
  final String? genreName;
  final AllMusicModel? allMusicModel;

  GenreDetails({
    @required this.genreName,
    @required this.allMusicModel,
  });

  @override
  State<GenreDetails> createState() => _GenreDetailsState();
}

class _GenreDetailsState extends State<GenreDetails> {
  AllMusicAllSongsModel? model;

  @override
  void initState() {
    super.initState();
    model = AllMusicAllSongsModel.fromJson(
      json: widget.allMusicModel!.toJson(),
      httpMsg: "Offline Data",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.genreName}")),
      body: genreDetailsWidget(
        context: context,
        model: model,
        genre: widget.genreName,
      ),
    );
  }
}
