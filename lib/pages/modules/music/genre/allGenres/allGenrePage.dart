import 'package:flutter/material.dart';
import 'package:rally/pages/modules/music/genre/genreDetails/genreDetails.dart';

import 'widget/allGenreWidget.dart';

class AllGenrePage extends StatefulWidget {
  const AllGenrePage({Key? key}) : super(key: key);

  @override
  State<AllGenrePage> createState() => _AllGenrePageState();
}

class _AllGenrePageState extends State<AllGenrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Genres")),
      body: allGenreWidget(
        context: context,
        onGenre: () => _onGenre(),
      ),
    );
  }

  void _onGenre() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GenreDetails(
          allMusicModel: null,
          genreName: '',
        ),
      ),
    );
  }
}
