// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetauditstatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAuditStatusModel _$AssetAuditStatusModelFromJson(
    Map<String, dynamic> json) {
  return AssetAuditStatusModel(
    id: json['id'] as int,
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$AssetAuditStatusModelToJson(
        AssetAuditStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };
