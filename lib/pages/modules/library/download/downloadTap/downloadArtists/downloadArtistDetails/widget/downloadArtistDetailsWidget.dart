import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget downloadArtistDetailsWidget({
  @required BuildContext? context,
  @required
      void Function(AllDownloadData data, AllDownloadContent content)?
          onMusicPlay,
  @required AllDownloadModel? model,
  @required
      Future<PaginatedItemsResponse<AllDownloadData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<AllDownloadData>? response,
  @required
      void Function(AllDownloadData data, AllDownloadContent content)?
          onMusicMore,
  @required void Function()? onPlayAll,
  @required String? artistid,
}) {
  int totalSong = 0;
  for (var item in model!.data!)
    for (var content in item.content!) {
      if (content.artistId == artistid && !content.isDownloading!) {
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
            bool show = false;
            for (var content in item.content!) {
              if (content.artistId == artistid && !content.isDownloading!) {
                show = true;
                break;
              }
            }
            return show
                ? Column(
                    children: [
                      for (var data in item.content!)
                        if (data.artistId == artistid && !data.isDownloading!)
                          contentDisplayFull(
                            context: context,
                            title: data.title,
                            artistName: data.stageName,
                            image: data.cover,
                            onContent: () => onMusicPlay!(item, data),
                            onContentMore: () => onMusicMore!(item, data),
                            onContentPlay: () => onMusicPlay!(item, data),
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
