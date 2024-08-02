import 'package:rally/spec/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

Widget buttomNavigationBar({
  @required int? selectedIndex,
  @required void Function(int index)? onItemTapped,
  @required double? elevation,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: double.maxFinite,
        color: BLACK,
        height: 1,
      ),
      BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.music),
            label: "Music",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_sharp, size: 30),
            label: "Playlists",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.briefcase),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.menu),
            label: "Others",
          ),
        ],
        currentIndex: selectedIndex!,
        unselectedItemColor: BLACK,
        selectedItemColor: PRIMARYCOLOR,
        iconSize: 25,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: onItemTapped,
        elevation: elevation,
        backgroundColor: BACKGROUND,
        type: BottomNavigationBarType.fixed,
      ),
    ],
  );
}
