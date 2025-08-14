// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriorityModel _$PriorityModelFromJson(Map<String, dynamic> json) {
  return PriorityModel(
    id: json['id'] as int,
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$PriorityModelToJson(PriorityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };
