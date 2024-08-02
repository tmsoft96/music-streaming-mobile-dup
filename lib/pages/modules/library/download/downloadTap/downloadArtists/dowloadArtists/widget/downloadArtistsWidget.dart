import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/models/allDownloadModel.dart';
import 'package:rally/providers/allArtistsProvider.dart';
// import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget downloadArtistsWidget({
  @required BuildContext? context,
  @required void Function(AllArtistData data)? onContent,
  @required
      Future<PaginatedItemsResponse<String>?> Function(bool)? fetchPageData,
  @required PaginatedItemsResponse<String>? response,
  @required AllDownloadModel? model,
}) {
  return PaginatedItemsBuilder<String>(
    response: response!,
    fetchPageData: (bool reset) => fetchPageData!(reset),
    itemBuilder: (BuildContext context, int index, item) {
      AllArtistData? artistData;
      int numberOfSongs = 0;
      for (var data in allArtistsModel!.data!) {
        if (data.userid.toString() == item) {
          artistData = data;
          break;
        }
      }
      for (var data in model!.data!) {
        for (var content in data.content!) {
          if (content.artistId == item && !content.isDownloading!) {
            numberOfSongs = numberOfSongs + 1;
          }
        }
      }
      return artistData != null && numberOfSongs > 0
          ? ListTile(
              minVerticalPadding: 20,
              onTap: () => onContent!(artistData!),
              leading: circular(
                child: cachedImage(
                  context: context,
                  image: artistData.picture,
                  height: 60,
                  width: 60,
                  placeholder: DEFAULTPROFILEPICOFFLINE,
                  diskCache: 150,
                ),
                size: 60,
              ),
              title: Text(
                artistData.stageName ?? artistData.name!,
                style: h4WhiteBold,
              ),
              subtitle: Text("$numberOfSongs songs", style: h6White),
            )
          : SizedBox();
    },
  );
}
