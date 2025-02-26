import 'package:flutter/material.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/pages/modules/admin/artist/adminViewAllArtist/enrollArtist/adminEnrollArtist.dart';
import 'package:rally/providers/allArtistsProvider.dart';

import 'widget/declinedArtistWidget.dart';

class DeclinedArtist extends StatefulWidget {
  const DeclinedArtist({Key? key}) : super(key: key);

  @override
  State<DeclinedArtist> createState() => _DeclinedArtistState();
}

class _DeclinedArtistState extends State<DeclinedArtist> {
  FocusNode? _searchFocusNode;
  String _searchText = "";

  AllArtistsProvider _provider = new AllArtistsProvider();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = new FocusNode();
    _provider.get(isLoad: true, fetchArtistType: 2);
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
            return emptyBox(context, msg: "${snapshot.data.msg}");
        } else if (snapshot.hasError) {
          return emptyBox(context, msg: "No data available");
        }
        return shimmerItem();
      },
    );
  }

  Widget _mainContent(AllArtistsModel model) {
    return declinedArtistWidget(
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
        builder: (context) => AdminEnrollArtist(data),
      ),
    );
  }
}
