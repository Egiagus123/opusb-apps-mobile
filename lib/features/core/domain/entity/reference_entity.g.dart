// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceEntity _$ReferenceEntityFromJson(Map<String, dynamic> json) {
  return ReferenceEntity(
    id: json['id'],
    identifier: json['identifier'] as String,
    propertyLabel: json['propertyLabel'] as String,
  );
}

Map<String, dynamic> _$ReferenceEntityToJson(ReferenceEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('propertyLabel', instance.propertyLabel);
  writeNotNull('identifier', instance.identifier);
  return val;
}
