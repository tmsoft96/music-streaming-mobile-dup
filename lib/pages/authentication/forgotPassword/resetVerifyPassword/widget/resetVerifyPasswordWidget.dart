import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/passwordField.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget resetVerifyPasswordWidget({
  @required TextEditingController? newPasswordController,
  @required TextEditingController? confirmPasswordController,
  @required FocusNode? newPasswordFocusNode,
  @required FocusNode? confirmPasswordFocusNode,
  @required void Function()? onResetPassword,
  @required BuildContext? context,
  @required Key? key,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Image.asset(LOGO, scale: 2),
            SizedBox(height: 20),
            Text("Reset Password", style: h3White),
            SizedBox(height: 30),
            Text("New Password", style: h5White),
            SizedBox(height: 10),
            PasswordField(
              hintText: "Enter password",
              controller: newPasswordController,
              focusNode: newPasswordFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 20),
            Text("Confirm Password", style: h5White),
            SizedBox(height: 10),
            PasswordField(
              hintText: "Confirm password",
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 20),
            button(
              onPressed: onResetPassword,
              text: "Reset Password",
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
