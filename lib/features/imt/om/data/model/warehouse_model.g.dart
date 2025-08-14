// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseModel _$WarehouseModelFromJson(Map<String, dynamic> json) {
  return WarehouseModel(
    inTransit: json['M_InTransitLocator_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_InTransitLocator_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WarehouseModelToJson(WarehouseModel instance) =>
    <String, dynamic>{
      'M_InTransitLocator_ID': instance.inTransit?.toJson(),
    };
