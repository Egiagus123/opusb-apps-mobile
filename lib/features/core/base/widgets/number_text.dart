import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberText extends StatelessWidget {
  final num number;
  final String numberFormat;

  const NumberText({
    required Key key,
    required this.number,
    this.numberFormat = '#,###',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return number == null
        ? Text('')
        : Text(NumberFormat(numberFormat).format(number));
  }
}
