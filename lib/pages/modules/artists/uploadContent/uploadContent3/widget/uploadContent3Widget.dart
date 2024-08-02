import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget uploadContent3Widget({
  @required BuildContext? context,
  @required TextEditingController? titleController,
  @required TextEditingController? descriptionController,
  @required TextEditingController? tagController,
  @required TextEditingController? stageNameController,
  @required FocusNode? titleFocusNode,
  @required FocusNode? descriptionFocusNode,
  @required FocusNode? stageNameFocusNode,
  @required FocusNode? tagFocusNode,
  @required void Function(int index)? onTagDelete,
  @required void Function()? onTagAdd,
  @required void Function()? onContinue,
  void Function()? onTermsAndCondition,
  @required void Function(String text)? onDescriptionTextChange,
  @required void Function(String text)? onTagTextChange,
  @required Key? key,
  @required int? descriptionLength,
  @required int? tagLength,
  @required List<dynamic>? tagsList,
  @required bool? isDescriptionFull,
  @required bool? isTagFull,
  @required Map<String, dynamic>? meta,
  bool isUpdate = false,
  @required List<Map<String, dynamic>>? publicationStatusList,
  @required void Function(int index)? onAlbumPublication,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Content Details", style: h4WhiteBold),
            SizedBox(height: 10),
            Text("Fill all required fields", style: h5White),
            SizedBox(height: 20),
            Text("Stage Name", style: h6WhiteBold),
            SizedBox(height: 3),
            Text(
              "Add all names if it's collaboration content.\nExample: (Michael ft. Beauty)",
              style: h5White,
            ),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter stage name",
              controller: stageNameController,
              focusNode: stageNameFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Text(
              meta == null
                  ? "Title"
                  : meta["contentType"] == 0
                      ? "Title"
                      : "Album Title",
              style: h6WhiteBold,
            ),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter title",
              controller: titleController,
              focusNode: titleFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Description (Optional)", style: h6WhiteBold),
                Text("$descriptionLength / 5000 words", style: h5White),
              ],
            ),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter description",
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              minLine: 5,
              maxLine: null,
              // maxLength: 5000,
              validate: false,
              showCounterText: false,
              validateMsg: REQUIREDFIELDMSG,
              onTextChange: (String text) => onDescriptionTextChange!(text),
              backgroundColor: isDescriptionFull! ? RED : PRIMARYCOLOR1,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tags", style: h6WhiteBold),
                Text("$tagLength / 5000 words", style: h5White),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "This helps in our search algorithm.\nSeparate each tag with \";\"",
              style: h5White,
            ),
            SizedBox(height: 10),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isTagFull! ? RED : PRIMARYCOLOR1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (int x = 0; x < tagsList!.length; ++x)
                        Chip(
                          label: Text("${tagsList[x]}"),
                          deleteIcon: Icon(
                            FeatherIcons.minusCircle,
                            color: RED,
                          ),
                          onDeleted: () => onTagDelete!(x),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  textFormField(
                    hintText: "Enter tag",
                    controller: tagController,
                    focusNode: tagFocusNode,
                    showBorderRound: false,
                    removeBorder: false,
                    borderColor: BLACK,
                    icon: Icons.add_circle,
                    iconColor: PRIMARYCOLOR,
                    onIconTap: onTagAdd,
                    validate: false,
                    onTextChange: (String text) => onTagTextChange!(text),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text("Publication Status", style: h6WhiteBold),
            SizedBox(height: 10),
            for (int x = 0; x < publicationStatusList!.length; ++x) ...[
              CheckboxListTile(
                value: publicationStatusList[x]["selected"],
                activeColor: PRIMARYCOLOR,
                onChanged: (bool? check) => onAlbumPublication!(x),
                tileColor: PRIMARYCOLOR1,
                title: Text(
                  publicationStatusList[x]["title"],
                  style: h6WhiteBold,
                ),
                subtitle: Text(
                  publicationStatusList[x]["description"],
                  style: h6White,
                ),
              ),
              Divider(),
            ],
            SizedBox(height: 20),
            if (isUpdate) ...[
              Wrap(
                children: [
                  Text(
                    "By clicking on the update button you agreed to our ",
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
                    textStyle: h5White,
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
            button(
              onPressed: onContinue,
              text: isUpdate ? "Update" : "Continue",
              color: PRIMARYCOLOR,
              context: context,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
