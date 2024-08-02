import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/cachedImage.dart';
import 'package:rally/components/circular.dart';
import 'package:rally/components/emptyBox.dart';
import 'package:rally/components/emptyBoxLinear.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/config/checkSession.dart';
import 'package:rally/config/globalFunction.dart';
import 'package:rally/models/commentModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:rally/spec/styles.dart';

Widget commentSectionWidget({
  @required BuildContext? context,
  @required bool? showTextBox,
  @required String? commentText,
  @required TextEditingController? commentController,
  @required FocusNode? commentFocusNode,
  @required void Function(bool reaction, CommentData data)? onReaction,
  @required void Function(String text)? onCommentChange,
  @required void Function()? onComment,
  @required void Function()? onSeeMore,
  @required CommentModel? model,
}) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (model != null && model.data!.length == 0)
                showTextBox!
                    ? emptyBox(context!, msg: "No comment...")
                    : emptyBoxLinear(context!, msg: "No comment..."),
              for (int x = 0;
                  x <
                      (showTextBox!
                          ? model!.data!.length
                          : model!.data!.length > 19
                              ? 20
                              : model.data!.length);
                  ++x)
                ListTile(
                  leading: circular(
                    child: cachedImage(
                      context: context,
                      image: "${model.data![x].profilePicture}",
                      height: 40,
                      width: 40,
                      placeholder: DEFAULTPROFILEPICOFFLINE,
                    ),
                    size: 40,
                  ),
                  title: Text(
                    "${model.data![x].name} - ${getTimeago(model.data![x].createdDate!.toDate())}",
                    style: h7White,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${model.data![x].comment}",
                        style: h5White,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => onReaction!(true, model.data![x]),
                            icon: Icon(Icons.thumb_up),
                            color:
                                model.data![x].isLike! ? PRIMARYCOLOR : BLACK,
                            iconSize: 20,
                          ),
                          if (model.data![x].likeReaction!.length > 0) ...[
                            SizedBox(width: 5),
                            Text(
                              "${getNumberFormat(model.data![x].likeReaction!.length)}",
                              style: h7White,
                            ),
                          ],
                          SizedBox(width: 40),
                          IconButton(
                            onPressed: () => onReaction!(false, model.data![x]),
                            icon: Icon(Icons.thumb_down),
                            color:
                                model.data![x].isUnlike! ? PRIMARYCOLOR : BLACK,
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (!showTextBox && model.data!.length > 19) ...[
                SizedBox(height: 20),
                button(
                  onPressed: onSeeMore,
                  text: "See More",
                  color: TRANSPARENT,
                  textColor: PRIMARYCOLOR,
                  context: context,
                  height: 30,
                  textStyle: h5BlackBold,
                ),
              ],
            ],
          ),
        ),
      ),
      if (showTextBox)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // height: 50,
            color: PRIMARYCOLOR1,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 10),
                circular(
                  child: cachedImage(
                    context: context,
                    image: userModel!.data!.user!.picture!,
                    height: 45,
                    width: 45,
                    placeholder: DEFAULTPROFILEPICOFFLINE,
                  ),
                  size: 45,
                ),
                SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: textFormField(
                    hintText: "Enter Comment",
                    controller: commentController,
                    focusNode: commentFocusNode,
                    onTextChange: (String text) => onCommentChange!(text),
                    width: MediaQuery.of(context!).size.width -
                        (commentText!.length > 0 ? 130 : 80),
                    borderColor: BLACK,
                    showBorderRound: false,
                    removeBorder: false,
                    maxLine: 10,
                    minLine: 1,
                  ),
                ),
                SizedBox(width: 10),
                if (commentText.length > 0)
                  CircleAvatar(
                    backgroundColor: PRIMARYCOLOR,
                    child: IconButton(
                      onPressed: onComment,
                      icon: Icon(Icons.send),
                      color: BLACK,
                    ),
                  ),
              ],
            ),
          ),
        ),
    ],
  );
}
