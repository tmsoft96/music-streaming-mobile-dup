import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/pages/modules/library/download/downloadTap/downloadAlbum/downloadAlbumDetails/downloadAlbumDetails.dart';

import 'widget/downloadAlbumWidget.dart';

class DownloadAlbum extends StatefulWidget {
  final AllDownloadModel? model;

  DownloadAlbum(this.model);

  @override
  State<DownloadAlbum> createState() => _DownloadAlbumState();
}

class _DownloadAlbumState extends State<DownloadAlbum> {
  PaginatedItemsResponse<AllDownloadData>? _postsResponse;

  PaginatedItemsResponse<AllDownloadData>? get postsResponse => _postsResponse;

  @override
  Widget build(BuildContext context) {
    _postsResponse = PaginatedItemsResponse<AllDownloadData>(
      listItems: Iterable.castFrom(widget.model!.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );

    return downloadAlbumWidget(
      context: context,
      fetchPageData: (bool) async {
        _postsResponse = PaginatedItemsResponse<AllDownloadData>(
          listItems: Iterable.castFrom(widget.model!.data!),
          // no support for pagination for current api
          paginationKey: null,
          idGetter: (post) => post.id.toString(),
        );
        return _postsResponse;
      },
      response: postsResponse,
      onContent: (AllDownloadData data) => _onContent(data),
      model: widget.model,
    );
  }

  void _onContent(AllDownloadData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DownloadAlbumDetails(
          data: data,
          model: widget.model,
        ),
      ),
    );
  }
}
