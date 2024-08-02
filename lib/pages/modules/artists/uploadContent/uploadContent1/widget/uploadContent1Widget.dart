import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/allGenreModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget uploadContent1Widget({
  @required BuildContext? context,
  @required List<Map<String, dynamic>>? contentTypeList,
  @required void Function(int index)? onContentType,
  @required void Function(int index)? onGenre,
  @required AllGenreModel? model,
}) {
  return Stack(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Select content type", style: h4WhiteBold),
            SizedBox(height: 10),
            Row(
              children: [
                for (int x = 0; x < contentTypeList!.length; ++x) ...[
                  GestureDetector(
                    onTap: () => onContentType!(x),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: contentTypeList[x]["selected"]
                            ? PRIMARYCOLOR.withOpacity(.6)
                            : BACKGROUND,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            contentTypeList[x]["image"],
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(height: 10),
                          Text(contentTypeList[x]["text"], style: h4WhiteBold),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ],
            ),
            SizedBox(height: 10),
            Text("Select genre", style: h4WhiteBold),
            SizedBox(height: 10),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 240),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int x = 0; x < model!.data!.length; ++x) ...[
                Container(
                  color: model.data![x].selected!
                      ? PRIMARYCOLOR.withOpacity(.6)
                      : BACKGROUND,
                  child: ListTile(
                    onTap: () => onGenre!(x),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cachedImage(
                        context: context,
                        image: "${model.data![x].cover}",
                        height: 60,
                        width: 60,
                      ),
                    ),
                    title: Text("${model.data![x].name}", style: h5WhiteBold),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}
