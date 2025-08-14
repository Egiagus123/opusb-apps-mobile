// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wostatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WOStatusModel _$WOStatusModelFromJson(Map<String, dynamic> json) {
  return WOStatusModel(
    id: json['id'] as int,
    name: json['name'] as String? ?? "",
    value: json['value'] as String? ?? "",
  );
}

Map<String, dynamic> _$WOStatusModelToJson(WOStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };
