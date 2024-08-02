import 'package:flutter/material.dart';
import 'package:rally/config/navigation.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/spec/colors.dart';

import 'widget/adminViewAllArtistWidget.dart';

class AdminViewAllArtist extends StatefulWidget {
  const AdminViewAllArtist({Key? key}) : super(key: key);

  @override
  State<AdminViewAllArtist> createState() => _AdminViewAllArtistState();
}

class _AdminViewAllArtistState extends State<AdminViewAllArtist> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    Repository repo = new Repository();
    repo.fetchAllArtists(true, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Artists")),
      body: adminViewAllArtistWidget(
        onTap: (int index) {
          setState(() {
            _tabIndex = index;
          });
        },
        tabIndex: _tabIndex,
        context: context,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigation(
          context: context,
          pageName: "completeartistenrollment",
        ),
        child: Icon(Icons.add, color: BLACK),
      ),
    );
  }
}
