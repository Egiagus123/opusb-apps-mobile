// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetmodels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetModel _$AssetModelFromJson(Map<String, dynamic> json) {
  return AssetModel(
    id: json['id'] as int,
    name: json['name'] as String,
    value: json['value'] as String,
    assetstatus: json['A_Asset_Status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['A_Asset_Status'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AssetModelToJson(AssetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'A_Asset_Status': instance.assetstatus,
    };
