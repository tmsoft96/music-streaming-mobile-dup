import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/allDownloadModel.dart';

Widget downloadWidget({
  @required BuildContext? context,
  @required AllDownloadModel? model,
  @required
      Future<PaginatedItemsResponse<AllDownloadData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<AllDownloadData>? response,
  @required void Function(AllDownloadData data, AllDownloadContent content)? onMusicMore,
  @required void Function(AllDownloadData data, AllDownloadContent content)? onMusicPlay,
  String? displayType,
}) {
  bool showLayout = false;
  for (var data in response!.items!)
    for (var content in data.content!) {
      if (displayType != "songs" && content.isDownloading!) {
        showLayout = true;
        break;
      }
    }

  return displayType == "songs" || showLayout ?  PaginatedItemsBuilder<AllDownloadData>(
    response: response,
    fetchPageData: (bool reset) => fetchPageData!(reset),
    itemBuilder: (BuildContext context, int index, item) {
      return Column(
        children: [
          for (var content in item.content!) ...[
            if (displayType == "songs" && !content.isDownloading!)
              contentDisplayFull(
                context: context,
                image: content.cover,
                streamNumber: null,
                title: content.title,
                artistName: content.stageName,
                onContent: () => onMusicPlay!(item, content),
                onContentMore: () => onMusicMore!(item, content),
                onContentPlay: () => onMusicPlay!(item, content),
                isDownload: content.isDownloading!,
                downloadPercentComplete: content.percentDownloadCompleteValue,
              ),
            if (displayType != "songs" && content.isDownloading!)
              contentDisplayFull(
                context: context,
                image: content.cover,
                streamNumber: null,
                title: content.title,
                artistName: content.stageName,
                onContent: () => onMusicPlay!(item, content),
                onContentMore: null,
                onContentPlay: null,
                isDownload: content.isDownloading!,
                downloadPercentComplete: content.percentDownloadCompleteValue,
              ),
          ],
        ],
      );
    },
    loaderItemsCount: 20,
  ) : emptyBox(context!, msg: "No on-going download");
}
