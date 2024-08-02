import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/models/reasonsModel.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/styles.dart';

Widget deleteAccountWidget({
  @required BuildContext? context,
  @required void Function(int index)? onSelectReason,
  @required void Function()? onDelete,
  @required int? selectedReasonIndex,
  @required String? selectedReason,
  @required TextEditingController? reasonController,
  @required FocusNode? reasonFocusNode,
  @required ReasonsModel? model,
}) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (int x = 0; x < model!.data!.length; ++x) ...[
            Card(
              color: PRIMARYCOLOR1,
              child: ListTile(
                onTap: () => onSelectReason!(x),
                title: Text(
                  model.data![x],
                  style: h5White,
                ),
                leading: Checkbox(
                  value: model.data![x] == selectedReason,
                  onChanged: (value) => onSelectReason!(x),
                  activeColor: PRIMARYCOLOR,
                ),
              ),
            ),
          ],
          if (selectedReasonIndex == model.data!.length - 1) ...[
            SizedBox(height: 10),
            textFormField(
              hintText: "Type reason here",
              controller: reasonController,
              focusNode: reasonFocusNode,
              minLine: 8,
              maxLine: null,
              borderRadius: 10,
              removeBorder: false,
              borderColor: PRIMARYCOLOR1,
            ),
          ],
          SizedBox(height: 20),
          button(
            onPressed: onDelete,
            text: "Delete",
            color: RED,
            context: context,
            divideWidth: .9,
            textColor: BLACK,
          ),
        ],
      ),
    ),
  );
}
