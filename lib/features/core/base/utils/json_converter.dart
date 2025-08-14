// ignore_for_file: unnecessary_null_comparison

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

toNull(_) => null;

class DateTimeJsonConverter implements JsonConverter<DateTime, String> {
  const DateTimeJsonConverter();

  @override
  DateTime fromJson(String json) {
    if (json == null) return DateTime.now(); // Or any default value
    return DateFormat('MM/dd/yyyy').parse(json);
  }

  @override
  String toJson(DateTime json) => DateFormat('MM/dd/yyyy').format(json);
}
