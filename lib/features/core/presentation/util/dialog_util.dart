import 'package:flutter/material.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';

AlertDialog buildAlertDialog(BuildContext context,
    {required String title,
    required String content,
    String? cancelText,
    VoidCallback? cancelCallback,
    String? proceedText = 'Ok',
    VoidCallback? proceedCallback}) {
  List<MaterialButton> actions = [];

  if (cancelText != null) {
    MaterialButton cancelButton = MaterialButton(
      onPressed: cancelCallback ?? () {},
      child: Text(
        cancelText,
        style: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    actions.add(cancelButton);
  }

  actions.add(MaterialButton(
      color: greenButton,
      child: Text(
        proceedText!,
        style: TextStyle(color: purewhiteTheme),
      ),
      onPressed: proceedCallback ?? () {}));

  return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
      ),
      content: Text(content, style: TextStyle(fontFamily: 'Montserrat')),
      actions: actions);
}
