import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget verifyAcountWidget({
  @required TextEditingController? codeController,
  @required FocusNode? codeFocusNode,
  @required BuildContext? context,
  @required Key? key,
  @required void Function()? onVerify,
  @required void Function()? onResend,
  bool isVerifyPin = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Image.asset(LOGO, scale: 2),
            SizedBox(height: 50),
            Text(
              isVerifyPin ? "Verify Pin" : "Verify Account",
              style: h3White,
            ),
            SizedBox(height: 20),
            Text(
              "Thanks for signing up! Before getting started, could you verify your email address by entering the code or clicking on the link we just emailed to you? If you didn't receive the email, we will gladly send you another by clicking ok the resend button below.",
              style: h5White,
            ),
            SizedBox(height: 30),
            textFormField(
              labelText: "Verification Code",
              hintText: "Enter code",
              controller: codeController,
              focusNode: codeFocusNode,
              validateMsg: REQUIREDFIELDMSG,
            ),
            SizedBox(height: 40),
            button(
              onPressed: onVerify,
              text: "VERIFY",
              color: PRIMARYCOLOR,
              context: context,
            ),
            SizedBox(height: 20),
            button(
              onPressed: onResend,
              text: "Resend Code",
              color: TRANSPARENT,
              textColor: BLACK,
              textStyle: h5BlackBold,
              context: context,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}
