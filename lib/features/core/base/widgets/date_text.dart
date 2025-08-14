import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final DateTime? dateTime;
  final String? dateFormat;

  const DateText({
    Key? key,
    this.dateTime,
    this.dateFormat = 'yMd',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dateTime == null
        ? Text('')
        : Text(DateFormat(dateFormat).format(dateTime!));
  }
}
