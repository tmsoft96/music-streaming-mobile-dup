import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent3/uploadContent3.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget uploadContent5Widget({
  @required BuildContext? context,
  @required void Function()? onTermsAndCondition,
  @required void Function()? onSubmit,
  @required void Function()? onSeeMore,
  @required void Function(String content)? onContent,
  @required Map<String, dynamic>? meta,
  @required String? errorMsg,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("Stage Name", style: h6White),
            subtitle: Text(meta!["stageName"], style: h4WhiteBold),
          ),
          ListTile(
            title: Text("Title", style: h6White),
            subtitle: Text(meta["title"], style: h5WhiteBold),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PRIMARYCOLOR1,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                for (int x = 0; x < meta["contents"].length; ++x) ...[
                  GestureDetector(
                    onTap: () => onContent!(meta["contents"][x].path),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(meta["contentCover"]),
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${meta["contentsFileName"][x]}",
                            style: h5WhiteBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ],
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: cachedImage(
                context: context,
                image: meta["genreCover"],
                height: 60,
                width: 60,
              ),
            ),
            title: Text(meta["genre"], style: h4WhiteBold),
            subtitle: Text("Genre", style: h6White),
          ),
          SizedBox(height: 10),
          Text("Description", style: h5WhiteBold),
          SizedBox(height: 10),
          Text(
            meta["description"] == "" ? "N/A" : meta["description"],
            style: h6White,
          ),
          SizedBox(height: 20),
          Text("Tags", style: h5WhiteBold),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (int x = 0; x < meta["tags"]!.length; ++x)
                Chip(label: Text("${meta["tags"][x]}")),
            ],
          ),
          SizedBox(height: 10),
          Text("Publication Status", style: h5WhiteBold),
          SizedBox(height: 10),
          CheckboxListTile(
            value: publicationStatusList[meta["publicationStatusIndex"]]
                ["selected"],
            activeColor: PRIMARYCOLOR,
            onChanged: (check) {},
            tileColor: PRIMARYCOLOR1,
            title: Text(
              publicationStatusList[meta["publicationStatusIndex"]]["title"],
              style: h5WhiteBold,
            ),
            subtitle: Text(
              publicationStatusList[meta["publicationStatusIndex"]]
                  ["description"],
              style: h6White,
            ),
          ),
          SizedBox(height: 10),
          Text("Lyrics", style: h5WhiteBold),
          SizedBox(height: 10),
          Wrap(
            children: [
              Text(
                meta["lyrics"],
                style: h6White,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              button(
                onPressed: onSeeMore,
                text: "See More",
                color: BACKGROUND,
                context: context,
                textColor: PRIMARYCOLOR,
                textStyle: h5BlackBold,
                useWidth: false,
                padding: EdgeInsets.zero,
                height: 30,
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            children: [
              Text(
                "By clicking on the submit button you agreed to our ",
                style: h6White,
              ),
              button(
                onPressed: onTermsAndCondition,
                text: "Terms and condition",
                color: BACKGROUND,
                context: context,
                useWidth: false,
                textColor: PRIMARYCOLOR,
                padding: EdgeInsets.zero,
                height: 20,
                textStyle: h6White,
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Files will be check manually for copyright issues and other things.",
            style: h6White,
          ),
          SizedBox(height: 20),
          // if (errorMsg = "") ...[
          // Text(
          //   "$errorMsg",
          //   style: h6White,
          // ),
          // SizedBox(height: 20),
          // ],
          button(
            onPressed: onSubmit,
            text: "Submit",
            color: PRIMARYCOLOR,
            context: context,
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}
