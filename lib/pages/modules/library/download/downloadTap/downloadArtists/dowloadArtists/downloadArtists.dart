import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/pages/modules/library/download/downloadTap/downloadArtists/downloadArtistDetails/downloadArtistDetails.dart';

import 'widget/downloadArtistsWidget.dart';

class DownloadArtists extends StatefulWidget {
  final AllDownloadModel? model;

  DownloadArtists(this.model);

  @override
  State<DownloadArtists> createState() => _DownloadArtistsState();
}

class _DownloadArtistsState extends State<DownloadArtists> {
  List<String> _allArtistIdList = [];
  PaginatedItemsResponse<String>? _postsResponse;

  PaginatedItemsResponse<String>? get postsResponse => _postsResponse;

  @override
  void initState() {
    super.initState();
    _getArtists();
  }

  void _getArtists() {
    List<String> artistList = [];
    for (var data in widget.model!.data!) {
      for (var content in data.content!) {
        artistList.add(content.artistId!);
      }
    }
    _allArtistIdList = artistList.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_allArtistIdList.isEmpty) {
      return emptyBox(context, msg: "No Artist content downloaded");
    }
    _postsResponse = PaginatedItemsResponse<String>(
      listItems: Iterable.castFrom(_allArtistIdList),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post,
    );

    return downloadArtistsWidget(
      context: context,
      fetchPageData: (bool) async {
        _postsResponse = PaginatedItemsResponse<String>(
          listItems: Iterable.castFrom(_allArtistIdList),
          // no support for pagination for current api
          paginationKey: null,
          idGetter: (post) => post,
        );
        return _postsResponse;
      },
      response: postsResponse,
      model: widget.model,
      onContent: (AllArtistData data) => _onContent(data),
    );
  }

  void _onContent(AllArtistData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DownloadArtistDetails(
          artistData: data,
          model: widget.model,
        ),
      ),
    );
  }
}
