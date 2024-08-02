import 'package:flutter/material.dart';
import 'package:rally/components/customLoading.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/firebase/firebaseDynamicLink.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/pages/homepage/library/library.dart';
import 'package:rally/pages/homepage/mainHomeWidget/homeHeading.dart';
import 'package:rally/pages/homepage/musicPage/musicPage.dart';
import 'package:rally/pages/homepage/othersPage/othersPage.dart';
import 'package:rally/pages/homepage/searchMusic/searchMusic.dart';
import 'package:rally/providers/favoriteContentProvider.dart';
import 'package:rally/spec/arrays.dart';
import 'package:rally/utils/musicPlayer/musicPlayer.dart';

import '../../providers/checkUpdateProvider.dart';
import '../modules/updateApp/updateApp.dart';
import 'mainHomeWidget/bottomNavigationBar.dart';
import 'playLists/playlists.dart';

class MainHome extends StatefulWidget {
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  FirebaseDynamicLink _firebaseDynamicLink = new FirebaseDynamicLink();
  FavoriteContentProvider _favoriteContentProvider = new FavoriteContentProvider();

  bool _isLoading = false, _getBottomPositionValueOnce = true;
  int _selectedIndex = 0;
  String _title = "Music";

  @override
  void initState() {
    super.initState();
    _favoriteContentProvider.fetch();
    loadHomepageFiles();
    _firebaseDynamicLink.initDynamicLink(context);
    if (forceUser) checkUpdate();
  }

  void _onItemTapped(int index) {
    if (index == 0)
      _title = "Music";
    else if (index == 1)
      _title = "Playlists";
    else if (index == 2)
      _title = "Search";
    else if (index == 3)
      _title = "Library";
    else if (index == 4) _title = "Others";
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MusicPage(),
      Playlists(),
      SearchMusic(),
      // Podcast(),
      Library(),
      OthersPage(),
    ];

    // geting the phone bottom size
    if (_getBottomPositionValueOnce) {
      bottomValue = MediaQuery.of(context).size.height * .85;
      _getBottomPositionValueOnce = false;
    }

    return Scaffold(
      appBar: homeHeading(
        context: context,
        onGenre: () => navigation(context: context, pageName: "genres"),
        onNotification: () =>
            navigation(context: context, pageName: "notification"),
        onAccount: () => navigation(context: context, pageName: "account"),
        onDashboard: () => navigation(
          context: context,
          pageName:
              userModel!.data!.user!.role!.toLowerCase() == userTypeList[1]
                  ? "artisthomepage"
                  : "adminhomepage",
        ),
        title: '$_title',
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          if (_isLoading) customLoadingPage(),
        ],
      ),
      bottomNavigationBar: buttomNavigationBar(
        elevation: 1,
        onItemTapped: (int index) => _onItemTapped(index),
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
