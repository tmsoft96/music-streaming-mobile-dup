import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

import '../spec/colors.dart';

void coolAlertDialog({
  @required BuildContext? context,
  CoolAlertType type = CoolAlertType.info,
  @required String? text,
  String confirmBtnText = "Ok",
  String cancelBtnText = "Cancel",
  @required void Function()? onConfirmBtnTap,
  bool barrierDismissible = true,
}) {
  CoolAlert.show(
    context: context!,
    type: type,
    backgroundColor: PRIMARYCOLOR,
    text: text,
    confirmBtnText: confirmBtnText,
    cancelBtnText: cancelBtnText,
    confirmBtnColor: PRIMARYCOLOR,
    onConfirmBtnTap: onConfirmBtnTap,
    loopAnimation: true,
    barrierDismissible: barrierDismissible,
  );
}
