// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceModel _$ReferenceModelFromJson(Map<String, dynamic> json) {
  return ReferenceModel(
    id: json['id'],
    propertyLabel: json['propertyLabel'] as String,
    identifier: json['identifier'] as String,
  );
}

Map<String, dynamic> _$ReferenceModelToJson(ReferenceModel instance) {
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
