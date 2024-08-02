import 'package:flutter/material.dart';
import 'package:rally/components/contentDisplayHome1.dart';
import 'package:rally/models/allPlaylistsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget playlistsWidget({
  @required BuildContext? context,
  @required AllPlaylistsModel? model,
  @required void Function(String genre)? onGenre,
  @required void Function(AllPlaylistsData data)? onPlaylist,
  @required void Function(AllPlaylistsData data)? onPlaylistMore,
  @required void Function(AllPlaylistsData data)? onPlayPlaylist,
  @required void Function()? onSeeAll,
  @required String? genreDisplay,
}) {
  List<String> genreList = [];
  for (var data in model!.data!)
    if (data.genres!.length > 0) genreList.add(data.genres![0]);

  List<String> distinctGenreList = genreList.toSet().toList();

  print(distinctGenreList);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onGenre!("all"),
                child: Chip(
                  label: Text("All"),
                  labelStyle: h5White,
                  backgroundColor:
                      genreDisplay == "all" ? PRIMARYCOLOR : PRIMARYCOLOR1,
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () => onGenre!("mine"),
                child: Chip(
                  label: Text("Your Playlists"),
                  labelStyle: h5White,
                  backgroundColor: PRIMARYCOLOR1,
                ),
              ),
              SizedBox(width: 5),
              for (String genre in distinctGenreList) ...[
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () => onGenre!(genre),
                  child: Chip(
                    label: Text("$genre"),
                    labelStyle: h5White,
                    backgroundColor:
                        genreDisplay == genre ? PRIMARYCOLOR : PRIMARYCOLOR1,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (genreDisplay == "all")
                  for (String genre in distinctGenreList) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$genre", style: h4White),
                          // button(
                          //   onPressed: onSeeAll,
                          //   text: 'More >',
                          //   color: BACKGROUND,
                          //   context: context,
                          //   useWidth: false,
                          //   textColor: PRIMARYCOLOR,
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          for (var data in model.data!)
                            if (genre == data.genres![0] &&
                                data.content!.length > 0) ...[
                              contentDisplayHome1(
                                context: context,
                                title: data.title,
                                contentImage: data.media!.thumb,
                                onContent: () => onPlaylist!(data),
                                onContentMore: () => onPlaylistMore!(data),
                                onPlayContent: () => onPlayPlaylist!(data),
                                stageName:
                                    '${data.content!.length.toString()} songs',
                                streamNumber: null,
                              ),
                              SizedBox(width: 5),
                            ],
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                if (genreDisplay != "all") ...[
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var data in model.data!)
                        if (genreDisplay == data.genres![0] &&
                            data.content!.length > 0) ...[
                          contentDisplayHome1(
                            context: context,
                            title: data.title,
                            contentImage: data.media!.thumb,
                            onContent: () => onPlaylist!(data),
                            onContentMore: () => onPlaylistMore!(data),
                            onPlayContent: () => onPlayPlaylist!(data),
                            stageName:
                                '${data.content!.length.toString()} songs',
                            streamNumber: null,
                          ),
                          SizedBox(width: 5),
                        ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: 50),
      ],
    ),
  );
}
