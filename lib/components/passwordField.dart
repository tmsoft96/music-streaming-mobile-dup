import 'package:flutter/material.dart';
import 'package:rally/spec/colors.dart';

class PasswordField extends StatefulWidget {
  final Key? fieldKey;
  final String? hintText, labelText, validateMsg;
  final FormFieldSetter<String>? onSaved;
  final bool? validate, removeBorder;
  final IconData? prefixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  PasswordField({
    this.fieldKey,
    @required this.hintText,
    this.onSaved,
    this.validate = true,
    this.removeBorder = true,
    this.onFieldSubmitted,
    this.labelText,
    @required this.controller,
    @required this.validateMsg,
    @required this.focusNode,
    this.prefixIcon,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      focusNode: widget.focusNode,
      validator: (value) {
        if (value!.isEmpty && widget.validate!) {
          return widget.validateMsg;
        }
        return null;
      },
      onFieldSubmitted: widget.onFieldSubmitted,
      style: TextStyle(color: BLACK, fontWeight: FontWeight.w600),
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: ASHDEEP),
        labelText: widget.labelText,
        filled: true,
        fillColor: PRIMARYCOLOR1,
        labelStyle: TextStyle(color: WHITE),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, color: BLACK),
        enabledBorder: widget.removeBorder!
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: WHITE, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
        focusedBorder: widget.removeBorder!
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: WHITE, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
        border: widget.removeBorder!
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: WHITE, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: BLACK,
          ),
        ),
      ),
    );
  }
}
