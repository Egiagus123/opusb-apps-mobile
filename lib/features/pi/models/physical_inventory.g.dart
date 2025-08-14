// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalInventory _$PhysicalInventoryFromJson(Map<String, dynamic> json) {
  return PhysicalInventory(
    id: json['id'] as int,
    uid: json['uid'] as String,
    documentNo: json['documentNo'] as String,
    movementDate:
        const DateTimeJsonConverter().fromJson(json['movementDate'] as String),
    warehouse: json['M_Warehouse_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Warehouse_ID'] as Map<String, dynamic>),
    docStatus: json['docStatus'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['docStatus'] as Map<String, dynamic>),
    processed: json['processed'] as bool,
  );
}

Map<String, dynamic> _$PhysicalInventoryToJson(PhysicalInventory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'documentNo': instance.documentNo,
      'movementDate':
          const DateTimeJsonConverter().toJson(instance.movementDate),
      'M_Warehouse_ID': instance.warehouse,
      'docStatus': instance.docStatus,
      'processed': instance.processed,
    };
