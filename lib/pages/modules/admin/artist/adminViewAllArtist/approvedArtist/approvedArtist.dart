import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/config/repository/repo.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/pages/modules/admin/artist/adminArtistDetails/adminArtistDetails.dart';
import 'package:rally/providers/allArtistsProvider.dart';

import 'widget/approvedArtistWidget.dart';

class ApprovedArtist extends StatefulWidget {
  @override
  State<ApprovedArtist> createState() => _ApprovedArtistState();
}

class _ApprovedArtistState extends State<ApprovedArtist> {
  FocusNode? _searchFocusNode;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadFile();
    _searchFocusNode = new FocusNode();
  }

  Future<void> _loadFile() async {
    Repository repo = new Repository();
    repo.fetchAllArtists(true, 0);
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: allArtistsModelStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.ok)
            return _mainContent(snapshot.data);
          else
            return  emptyBox(context, msg: "${snapshot.data.msg}");
               
        } else if (snapshot.hasError) {
          return emptyBox(context, msg: "No data available");
        }
        return shimmerItem();
      },
    );
  }

  Widget _mainContent(AllArtistsModel model) {
    return approvedArtistWidget(
      onSearch: (String text) {
        setState(() {
          _searchText = text;
        });
      },
      searchFocusNode: _searchFocusNode,
      onArtist: (AllArtistData data) => _onArtist(data),
      context: context,
      model: model,
      searchText: _searchText,
    );
  }

  void _onArtist(AllArtistData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminArtistDetails(data),
      ),
    );
  }
}
