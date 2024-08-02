import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/models/allAlbumModel.dart';
import 'package:rally/models/allMusicModel.dart';
import 'package:rally/components/contentDisplayFull.dart';
import 'package:rally/pages/modules/artists/uploadContent/uploadContent3/widget/uploadContent3Widget.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget updateContentWidget({
  @required BuildContext? context,
  @required void Function()? onUploadContentCover,
  @required void Function()? onContent,
  @required String? contentCover,
  @required AllMusicData? allMusicData,
  @required AllAlbumData? allAlbumData,
  @required TextEditingController? titleController,
  @required TextEditingController? descriptionController,
  @required TextEditingController? tagController,
  @required FocusNode? titleFocusNode,
  @required FocusNode? descriptionFocusNode,
  @required FocusNode? tagFocusNode,
  @required void Function(int index)? onTagDelete,
  @required void Function()? onTagAdd,
  @required void Function()? onPreview,
  @required void Function()? onTermsAndCondition,
  @required void Function(String text)? onDescriptionTextChange,
  @required void Function(String text)? onTagTextChange,
  @required Key? key,
  @required int? descriptionLength,
  @required int? tagLength,
  @required List<dynamic>? tagsList,
  @required bool? isDescriptionFull,
  @required bool? isTagFull,
  @required List<Map<String, dynamic>>? albumPublicationList,
  @required void Function(int index)? onAlbumPublication,
  @required Map<String, dynamic>? meta,
  @required TextEditingController? stageNameController,
  @required FocusNode? stageNameFocusNode,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          if (allMusicData != null) ...[
            contentDisplayFull(
              context: context,
              image: allMusicData.media!.thumb,
              streamNumber: allMusicData.streams!.length,
              title: allMusicData.title,
              onContent: () => onContent!(),
              onContentMore: null,
              onContentPlay: null,
              artistName: allMusicData.stageName,
            ),
            SizedBox(height: 10),
          ],
          Text(
            allMusicData != null ? "Content cover" : "Album Cover",
            style: h4WhiteBold,
          ),
          SizedBox(height: 10),
          if (contentCover! != "")
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(contentCover),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          if (contentCover == "")
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: cachedImage(
                  width: 150,
                  height: 150,
                  context: context,
                  image: allMusicData != null
                      ? allMusicData.media!.normal
                      : allAlbumData!.media!.normal,
                  diskCache: null,
                ),
              ),
            ),
          SizedBox(height: 10),
          if (allMusicData != null) ...[
            Center(child: Text("Max. Size: 5000 X 5000px", style: h5Red)),
            SizedBox(height: 10),
            Center(
              child: button(
                onPressed: onUploadContentCover,
                text: "Edit",
                color: PRIMARYCOLOR.withOpacity(.3),
                context: context,
                useWidth: false,
                textColor: BLACK,
                textStyle: h5BlackBold,
                buttonRadius: 10,
                height: 40,
              ),
            ),
          ],
          uploadContent3Widget(
            context: context,
            titleController: titleController,
            descriptionController: descriptionController,
            tagController: tagController,
            titleFocusNode: titleFocusNode,
            descriptionFocusNode: descriptionFocusNode,
            tagFocusNode: tagFocusNode,
            onTagDelete: onTagDelete,
            onTagAdd: onTagAdd,
            onContinue: onPreview,
            onDescriptionTextChange: onDescriptionTextChange,
            onTagTextChange: onTagTextChange,
            key: key,
            descriptionLength: descriptionLength,
            tagLength: tagLength,
            tagsList: tagsList,
            isDescriptionFull: isDescriptionFull,
            isTagFull: isTagFull,
            meta: meta,
            isUpdate: true,
            publicationStatusList: albumPublicationList,
            onAlbumPublication: (int index) => onAlbumPublication!(index),
            stageNameController: stageNameController,
            stageNameFocusNode: stageNameFocusNode,
            onTermsAndCondition: onTermsAndCondition,
          ),
        ],
      ),
    ),
  );
}
