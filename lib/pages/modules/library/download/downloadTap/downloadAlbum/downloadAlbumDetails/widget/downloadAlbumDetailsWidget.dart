import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget downloadAlbumDetailsWidget({
  @required BuildContext? context,
  @required void Function(AllDownloadContent content)? onMusicPlay,
  @required AllDownloadModel? model,
  @required
      Future<PaginatedItemsResponse<AllDownloadData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<AllDownloadData>? response,
  @required void Function(AllDownloadContent content)? onMusicMore,
  @required void Function()? onPlayAll,
  @required AllDownloadData? data,
}) {
  int totalSong = 0;
  for (var content in data!.content!) {
    if (!content.isDownloading!) {
      ++totalSong;
    }
  }

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
            Text("$totalSong songs", style: h5White),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 50),
        child: PaginatedItemsBuilder<AllDownloadData>(
          response: response,
          fetchPageData: (bool reset) => fetchPageData!(reset),
          itemBuilder: (BuildContext context, int index, item) {
            return item.id!.contains("album") ||
                    item.id!.contains("playlist") ||
                    item.id!.contains("banner")
                ? Column(
                    children: [
                      for (var content in item.content!)
                        if (item.id == data.id && !content.isDownloading!)
                          contentDisplayFull(
                            context: context,
                            title: content.title,
                            artistName: content.stageName,
                            image: content.cover,
                            onContent: () => onMusicPlay!(content),
                            onContentMore: () => onMusicMore!(content),
                            onContentPlay: () => onMusicPlay!(content),
                            streamNumber: null,
                          ),
                    ],
                  )
                : SizedBox();
          },
          loaderItemsCount: 20,
        ),
      ),
    ],
  );
}
