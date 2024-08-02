import 'package:rally/components/button.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/images.dart';
import 'package:flutter/material.dart';
import 'package:rally/components/textField.dart';
import 'package:rally/spec/strings.dart';
import 'package:rally/spec/styles.dart';

Widget forggetPasswordWidget({
  @required TextEditingController? emailController,
  @required FocusNode? emailFocusNode,
  @required BuildContext? context,
  @required Key? key,
  @required void Function()? onSubmit,
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
            Text("Forgot Password?", style: h3White),
            SizedBox(height: 20),
            Text(FORGETPASSWORDTEXT, style: h5White),
            SizedBox(height: 30),
            textFormField(
              labelText: "Email",
              hintText: "Enter email",
              controller: emailController,
              focusNode: emailFocusNode,
              icon: Icons.email,
              validateEmail: true,
              validateMsg: REQUIREDFIELDMSG,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 40),
            button(
              onPressed: onSubmit,
              text: "SUBMIT",
              color: PRIMARYCOLOR,
              context: context,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}
