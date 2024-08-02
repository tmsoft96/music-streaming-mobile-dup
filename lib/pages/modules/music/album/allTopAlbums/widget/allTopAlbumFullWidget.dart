import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/models/allAlbumHomepageModel.dart';
import 'package:rally/components/contentDisplayAlbum.dart';

Widget allTopAlbumFullWidget({
  @required BuildContext? context,
  @required void Function(AllAlbumHomepageData data)? onAlbum,
  @required void Function(AllAlbumHomepageData data)? onAlbumMore,
  @required void Function(AllAlbumHomepageData data)? onPlayAlbum,
  @required AllAlbumHomepageModel? model,
  @required
      Future<PaginatedItemsResponse<AllAlbumHomepageData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<AllAlbumHomepageData>? response,
}) {
  bool showContent = false;
  for (var data in model!.data!) {
    if (data.files!.length > 0) {
      showContent = true;
      break;
    }
  }

  return showContent
      ? PaginatedItemsBuilder<AllAlbumHomepageData>(
          response: response!,
          fetchPageData: (bool reset) => fetchPageData!(reset),
          loaderItemsCount: 20,
          itemBuilder: (BuildContext context, int index, data) =>
              data.files!.length > 0
                  ? contentDisplayAlbum(
                      context: context,
                      image: data.media!.thumb,
                      title: data.name,
                      isPublic: data.public == "0",
                      noOfFiles: data.files!.length,
                      showBanner: userModel!.data!.user!.userid == data.userid,
                      onContentMore: () => onAlbumMore!(data),
                      artistName: data.stageName,
                      onContent: () => onAlbum!(data),
                      onPlayContent: () => onPlayAlbum!(data),
                    )
                  : SizedBox(),
        )
      : emptyBox(context!, msg: "No album available");
}
