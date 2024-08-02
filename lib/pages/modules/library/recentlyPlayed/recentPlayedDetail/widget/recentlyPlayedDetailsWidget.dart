import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayDetails.dart';
import 'package:rally/models/recentlyPlayedSingleModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget recentlyPlayedDetailsWidget({
  @required BuildContext? context,
  @required void Function(RecentlyPlayedSingleData data)? onMusic,
  @required void Function(RecentlyPlayedSingleData data)? onMusicDownload,
  @required RecentlyPlayedSingleModel? model,
  @required
      Future<PaginatedItemsResponse<RecentlyPlayedSingleData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<RecentlyPlayedSingleData>? response,
  @required
      void Function(dynamic action, RecentlyPlayedSingleData data)? onTrackMore,
  @required void Function()? onPlayAll,
}) {
  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            button(
              onPressed: onPlayAll,
              text: "Play All",
              color: PRIMARYCOLOR,
              context: context,
              textStyle: h4Black,
              useWidth: false,
              icon: Icon(Icons.play_arrow),
              height: 40,
            ),
            SizedBox(width: 10),
            Text("${model!.data!.length} songs", style: h5White),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 50),
        child: PaginatedItemsBuilder<RecentlyPlayedSingleData>(
          response: response!,
          fetchPageData: (bool reset) => fetchPageData!(reset),
          itemBuilder: (BuildContext context, int index, item) {
            return contentDisplayDetails(
              context: context,
              title: item.title,
              artistName: item.stageName,
              cover: item.thumb,
              onDownloadTrack: () => onMusicDownload!(item),
              onTrack: () => onMusic!(item),
              onTrackMore: (dynamic action) => onTrackMore!(action, item),
              contentId: item.id,
              contentType: 'single',
            );
          },
          loaderItemsCount: 20,
        ),
      ),
    ],
  );
}
