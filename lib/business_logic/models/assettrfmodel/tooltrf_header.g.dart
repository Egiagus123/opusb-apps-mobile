// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltrf_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToolsTrfHeader _$ToolsTrfHeaderFromJson(Map<String, dynamic> json) {
  return ToolsTrfHeader(
    description: json['description'] as String,
    detail: (json['detail'] as List?)!
        .whereType<Map<String, dynamic>>() // Filters out any null values
        .map(
            (e) => ToolsTrfLine.fromJson(e)) // Convert each Map to ToolsTrfLine
        .toList(),
    documentNo: json['documentNo'] as String,
  );
}

Map<String, dynamic> _$ToolsTrfHeaderToJson(ToolsTrfHeader instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('documentNo', instance.documentNo);
  val['description'] = instance.description;
  val['detail'] = instance.detail;
  return val;
}
