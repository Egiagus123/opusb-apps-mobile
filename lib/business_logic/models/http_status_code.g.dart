// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_status_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpStatusCode _$HttpStatusCodeFromJson(Map<String, dynamic> json) {
  return HttpStatusCode(
    status: json['status'] as int,
    title: json['title'] as String,
    detail: json['detail'] as String,
  );
}

Map<String, dynamic> _$HttpStatusCodeToJson(HttpStatusCode instance) =>
    <String, dynamic>{
      'status': instance.status,
      'title': instance.title,
      'detail': instance.detail,
    };
