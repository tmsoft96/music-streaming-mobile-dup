import 'package:flutter/material.dart';
import 'package:rally/components/button.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget addReportWidget({
  @required BuildContext? context,
  @required void Function()? onReport,
  @required TextEditingController? emailController,
  @required TextEditingController? phoneController,
  @required TextEditingController? reasonController,
  @required FocusNode? reasonFocusNode,
  @required FocusNode? emailFocusNode,
  @required FocusNode? phoneFocusNode,
  @required Key? key,
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
            Text("Email (Optional)", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter your email",
              controller: emailController,
              focusNode: emailFocusNode,
              validate: false,
            ),
            SizedBox(height: 10),
            Text("Phone (Optional)", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter phone",
              controller: phoneController,
              focusNode: phoneFocusNode,
              validate: false,
            ),
            SizedBox(height: 10),
            Text("State Reason", style: h5WhiteBold),
            SizedBox(height: 10),
            textFormField(
              hintText: "Enter reason of report",
              controller: reasonController,
              focusNode: reasonFocusNode,
              validateMsg: REQUIREDFIELDMSG,
              maxLine: null,
              minLine: 6,
            ),
            SizedBox(height: 30),
            button(
              onPressed: onReport,
              text: "Report",
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
