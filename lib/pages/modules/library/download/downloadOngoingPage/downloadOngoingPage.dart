import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/components/toast.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/providers/allDownloadProvider.dart';
import 'package:rally/spec/colors.dart';

import 'widget/downloadWidget.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  PaginatedItemsResponse<AllDownloadData>? _postsResponse;

  PaginatedItemsResponse<AllDownloadData>? get postsResponse => _postsResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloads")),
      body: StreamBuilder(
        stream: allDownloadStream,
        initialData: allDownloadModel ?? null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.data != null
                ? _mainContent(snapshot.data)
                : emptyBox(context, msg: "No download file available");
          } else if (snapshot.hasError) {
            return emptyBox(context, msg: "No download file available");
          }
          return shimmerItem(numOfItem: 6);
        },
      ),
    );
  }

  Widget _mainContent(AllDownloadModel model) {
    _postsResponse = PaginatedItemsResponse<AllDownloadData>(
      listItems: Iterable.castFrom(model.data!),
      // no support for pagination for current api
      paginationKey: null,
      idGetter: (post) => post.id.toString(),
    );

    return downloadWidget(
      context: context,
      model: model,
      onMusicPlay: (AllDownloadData data, AllDownloadContent content) {
        toastContainer(
          text: "Content currently downloading",
          backgroundColor: RED,
        );
      },
      fetchPageData: (bool) async {
        _postsResponse = PaginatedItemsResponse<AllDownloadData>(
          listItems: Iterable.castFrom(model.data!),
          // no support for pagination for current api
          paginationKey: null,
          idGetter: (post) => post.id.toString(),
        );
        return _postsResponse;
      },
      response: postsResponse,
      onMusicMore: null,
    );
  }
}
