// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Locator _$LocatorFromJson(Map<String, dynamic> json) {
  return Locator(
    id: json['id'] as int,
    uid: json['uid'] as String,
    warehouse: json['M_Warehouse_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Warehouse_ID'] as Map<String, dynamic>),
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$LocatorToJson(Locator instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'M_Warehouse_ID': instance.warehouse,
      'value': instance.value,
    };
