import 'package:flutter/material.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/pages/modules/library/favoriteDetails/favoriteDetails.dart';

import 'widget/libraryWidget.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return libraryWidget(
      onShowDownload: () => navigation(
        context: context,
        pageName: "downloadlibrary",
      ),
      context: context,
      tabIndex: _tabIndex,
      onTap: (int index) {
        setState(() {
          _tabIndex = index;
        });
      },
      onFavoriteAlbums: () => _onFavoritePage("album"),
      onFavoritePlaylist: () => _onFavoritePage("playlist"),
      onFavoriteSongs: () => _onFavoritePage("single"),
      onFollwedArtists: () => navigation(
        context: context,
        pageName: "followedartists",
      ),
      onMyPlaylists: () => navigation(
        context: context,
        pageName: "myplaylists",
      ),
    );
  }

  void _onFavoritePage(String contentType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavoriteDetails(contentType),
      ),
    );
  }
}
