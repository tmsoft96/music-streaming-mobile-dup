import 'package:flutter/material.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/allGenreModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget selectGenreWidget({
  @required BuildContext? context,
  @required AllGenreModel? model,
  @required void Function(int index)? onGenre,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
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
                    diskCache: 150,
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
  );
}
