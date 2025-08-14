// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reference _$ReferenceFromJson(Map<String, dynamic> json) {
  return Reference(
    propertyLabel: json['propertyLabel'] as String? ?? '',
    id: json['id'],
    identifier: json['identifier'] as String? ?? '',
    modelName: json['modelName'] as String? ?? '',
    value: json['value'] as String? ?? '',
  );
}

Map<String, dynamic> _$ReferenceToJson(Reference instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('propertyLabel', instance.propertyLabel);
  writeNotNull('id', instance.id);
  writeNotNull('identifier', instance.identifier);
  writeNotNull('modelName', instance.modelName);
  writeNotNull('value', instance.value);
  return val;
}
