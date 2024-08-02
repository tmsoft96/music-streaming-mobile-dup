import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';
import 'package:rally/spec/properties.dart';

Widget textFormField({
  Function()? function,
  @required String? hintText,
  String? labelText,
  String? validateMsg,
  IconData? icon,
  IconData? prefixIcon,
  Color iconColor = BLACK,
  Color prefixIconColor = BLACK,
  Color? cursorColor,
  Color textColor = BLACK,
  Color labelColor = BLACK,
  Color backgroundColor = PRIMARYCOLOR1,
  @required TextEditingController? controller,
  bool validate = true,
  bool suggestion = false,
  TextInputType inputType = TextInputType.text,
  int? maxLine = 1,
  int? minLine = 1,
  bool validateEmail = false,
  double? width,
  enable = true,
  bool removeBorder = true,
  void Function()? onIconTap,
  TextInputAction? inputAction,
  void Function()? onEditingComplete,
  void Function(String text)? onTextChange,
  @required FocusNode? focusNode,
  bool readOnly = false,
  bool showBorderRound = true,
  Color borderColor = WHITE,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
  int? maxLength,
  double borderWidth = 1,
  double borderRadius = 20,
  bool isDense = false,
  bool showCounterText = true,
}) {
  return Container(
    width: width,
    child: TextFormField(
      onTap: function,
      readOnly: readOnly,
      enableInteractiveSelection: true,
      enabled: enable,
      enableSuggestions: suggestion,
      keyboardType: inputType,
      controller: controller,
      minLines: minLine,
      maxLines: maxLine,
      maxLength: maxLength,
      focusNode: focusNode,
      autofocus: false,
      textInputAction: inputAction,
      cursorColor: cursorColor,
      textCapitalization:
          validateEmail ? TextCapitalization.none : textCapitalization,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      onEditingComplete: () {
        print(controller!.text);
        focusNode!.unfocus();
        // onEditingComplete();
      },
      onChanged: onTextChange == null ? null : (text) => onTextChange(text),
      decoration: InputDecoration(
        isDense: isDense,
        hintText: hintText,
        hintStyle: TextStyle(color: ASHDEEP),
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        filled: true,
        fillColor: backgroundColor,
        suffixIcon: icon == null
            ? null
            : GestureDetector(
                onTap: onIconTap,
                child: Icon(icon, color: iconColor),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: prefixIconColor),
        enabledBorder: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        disabledBorder: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        focusedBorder: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: WHITE,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: WHITE,
                      width: borderWidth,
                    ),
                  ),
        border: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        errorStyle: TextStyle(
          color: Colors.red,
        ),
        counterStyle: showCounterText
            ? null
            : TextStyle(
                height: double.minPositive,
              ),
        counterText: showCounterText ? null : "",
      ),
      validator: (value) {
        RegExp regex = new RegExp(PATTERN);
        if (value!.isEmpty && validate) {
          return validateMsg;
        } else if (validateEmail && !regex.hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      },
    ),
  );
}
