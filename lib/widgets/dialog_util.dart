import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:flutter/material.dart';

AlertDialog buildAlertDialog(BuildContext context,
    {required String title,
    required String content,
    required String cancelText,
    required VoidCallback cancelCallback,
    String proceedText = 'Ok',
    required VoidCallback proceedCallback}) {
  List<Widget> actions = [];

  // Membuat tombol cancel hanya jika cancelText tidak kosong
  if (cancelText.isNotEmpty) {
    actions.add(TextButton(
      child: Text(
        cancelText,
        style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold),
      ),
      onPressed: cancelCallback,
    ));
  }

  actions.add(ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: greenButton, // warna button
    ),
    child: Text(
      proceedText,
      style: TextStyle(color: purewhiteTheme),
    ),
    onPressed: proceedCallback,
  ));

  return AlertDialog(
    title: Text(
      title,
      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
    ),
    content: Text(content, style: TextStyle(fontFamily: 'Montserrat')),
    actions: actions,
  );
}
