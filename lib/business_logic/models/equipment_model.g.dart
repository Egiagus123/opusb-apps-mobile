// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentModel _$EquipmentModelFromJson(Map<String, dynamic> json) {
  return EquipmentModel(
    id: json['id'] as int,
    documentNo: json['documentNo'] as String,
    serNo: json['serNo'] as String,
  );
}

Map<String, dynamic> _$EquipmentModelToJson(EquipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentNo': instance.documentNo,
      'serNo': instance.serNo,
    };
