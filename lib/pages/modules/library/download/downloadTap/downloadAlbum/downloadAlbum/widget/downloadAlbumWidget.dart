import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget downloadAlbumWidget({
  @required BuildContext? context,
  @required void Function(AllDownloadData data)? onContent,
  @required
      Future<PaginatedItemsResponse<AllDownloadData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<AllDownloadData>? response,
  @required AllDownloadModel? model,
}) {
  bool showLayout = false;
  for (var data in response!.items!) {
    if (data.id!.contains("album") ||
        data.id!.contains("playlist") ||
        data.id!.contains("banner")) {
      showLayout = true;
      break;
    }
  }

  return showLayout
      ? PaginatedItemsBuilder<AllDownloadData>(
          response: response,
          fetchPageData: (bool reset) => fetchPageData!(reset),
          itemBuilder: (BuildContext context, int index, item) {
            bool show = false;
            int totalSong = 0;
            for (var content in item.content!) {
              if ((item.id!.contains("album") ||
                      item.id!.contains("playlist") ||
                      item.id!.contains("banner")) &&
                  !content.isDownloading!) {
                show = true;
                ++totalSong;
              }
            }
            return show
                ? ListTile(
                    minVerticalPadding: 20,
                    onTap: () => onContent!(item),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cachedImage(
                        context: context,
                        image: item.cover,
                        height: 60,
                        width: 60,
                        placeholder: DEFAULTPROFILEPICOFFLINE,
                        diskCache: 150,
                      ),
                    ),
                    title: Text(item.title!, style: h4WhiteBold),
                    subtitle: Row(
                      children: [
                        if (item.id!.contains("album")) ...[
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: GREEN,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Album", style: h6White),
                          ),
                          SizedBox(width: 10),
                        ],
                        Text("$totalSong songs", style: h6White),
                      ],
                    ),
                  )
                : SizedBox();
          },
        )
      : emptyBox(context!, msg: "No album downloaded");
}
