import 'package:flutter/material.dart';
import 'package:paginated_items_builder/paginated_items_builder.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/allArtistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget allArtistsFullWidget({
  @required BuildContext? context,
  @required void Function(AllArtistData data)? onContent,
  @required AllArtistsModel? model,
  @required
      Future<PaginatedItemsResponse<AllArtistData>?> Function(bool)?
          fetchPageData,
  @required PaginatedItemsResponse<AllArtistData>? response,
}) {
  return PaginatedItemsBuilder<AllArtistData>(
    response: response!,
    fetchPageData: (bool reset) => fetchPageData!(reset),
    itemBuilder: (BuildContext context, int index, data) {
      return ListTile(
        minVerticalPadding: 20,
        onTap: () => onContent!(data),
        leading: circular(
          child: cachedImage(
            context: context,
            image: data.picture,
            height: 60,
            width: 60,
            placeholder: DEFAULTPROFILEPICOFFLINE,
            diskCache: 150,
          ),
          size: 60,
        ),
        title: Text(
          data.stageName ?? data.name!,
          style: h4WhiteBold,
        ),
        subtitle: Row(
          children: [
            Text(
              "${getNumberFormat(int.parse(data.followersCount!))} Followers  -",
              style: h6White,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 5),
            Icon(Icons.headphones, color: BLACK, size: 10),
            SizedBox(width: 5),
            Text(
              "${getNumberFormat(int.parse(data.streamsCount!))}",
              style: h6White,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    },
  );
}
