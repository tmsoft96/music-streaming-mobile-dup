import 'package:flutter/material.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/shimmerItem.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/components/contentDisplayFull.dart';

Widget artistMusicVideoFullWidget({
  @required BuildContext? context,
  @required void Function(AllMusicData data)? onMusic,
  @required void Function(AllMusicData data)? onContentMore,
  @required void Function(AllMusicData data)? onContentPlay,
  @required AllMusicModel? model,
  @required
      Future<List<AllMusicData>> Function(int offset, AllMusicModel model)?
          pageFetch,
}) {
  bool isShow = false;
  for (int x = 0; x < model!.data!.length; ++x)
    if (model.data![x].filepath!.split("/").last.contains("mp4")) {
      isShow = true;
      break;
    }

  return isShow
      ? PaginationView<AllMusicData>(
          preloadedItems: model.data,
          itemBuilder: (BuildContext context, AllMusicData data, int index) {
            return data.filepath!.split("/").last.contains("mp4")
                ? GestureDetector(
                    onTap: () => onMusic!(data),
                    child: contentDisplayFull(
                      context: context,
                      image: data.cover,
                      streamNumber: data.streams!.length,
                      title: data.title,
                      onContentMore: () => onContentMore!(data),
                      onContentPlay: () => onContentPlay!(data),
                      artistName: data.stageName,
                      onContent: () => onMusic!(data),
                    ),
                  )
                : SizedBox();
          },
          // header: SliverToBoxAdapter(child: Text('Header text')),
          // footer: SliverToBoxAdapter(child: Text('Footer text')),
          paginationViewType: PaginationViewType.listView, // optional
          pageFetch: (int index) => pageFetch!(index, model),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 10 / 16,
            maxCrossAxisExtent: 320,
          ),
          physics: BouncingScrollPhysics(),
          onError: (dynamic error) => Center(
            child: Text('Some error occured'),
          ),
          onEmpty: Center(
            child: Text('Sorry! This is empty'),
          ),
          bottomLoader: shimmerItem(numOfItem: 1),
          initialLoader: shimmerItem(numOfItem: 20),
        )
      : emptyBox(context!, msg: "No data available");
}
