import 'package:flutter/material.dart';

AlertDialog buildAlertDialog(BuildContext context,
    {required String title,
    required String content,
    String? cancelText,
    VoidCallback? cancelCallback,
    String proceedText = 'Ok',
    required VoidCallback proceedCallback}) {
  List<Widget> actions = [];

  // Membuat tombol cancel hanya jika cancelText tidak null
  if (cancelText != null) {
    actions.add(TextButton(
      child: Text(cancelText),
      onPressed: cancelCallback ?? () {},
    ));
  }

  // Tombol proceed
  actions.add(ElevatedButton(
    child: Text(proceedText),
    onPressed: proceedCallback,
  ));

  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: actions,
  );
}
