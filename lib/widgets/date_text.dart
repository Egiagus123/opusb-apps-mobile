import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class DateText extends StatelessWidget {
  final DateTime dateTime;
  final String dateFormat;
  final String freetext;

  const DateText({
    Key? key,
    required this.freetext,
    required this.dateTime,
    this.dateFormat = 'yMd',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dateTime == null
        ? Text('')
        : Text(freetext + formatDate(dateTime, [mm, '/', dd, '/', yyyy]));
  }
}
