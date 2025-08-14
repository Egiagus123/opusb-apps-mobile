// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerErrorModel _$ServerErrorModelFromJson(Map<String, dynamic> json) {
  return ServerErrorModel(
    title: json['title'] as String,
    status: json['status'] as int,
    detail: json['detail'] as String,
  );
}

Map<String, dynamic> _$ServerErrorModelToJson(ServerErrorModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'status': instance.status,
      'detail': instance.detail,
    };
