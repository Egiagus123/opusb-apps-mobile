// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentTemporarry _$ShipmentTemporarryFromJson(Map<String, dynamic> json) {
  return ShipmentTemporarry(
    id: json['id'] as int,
    container: json['TRM_M_CONT_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['TRM_M_CONT_ID'] as Map<String, dynamic>),
    containerNo: json['containerNo'] as String,
    Tare_Weight: json['Tare_Weight'] as String,
    qtyEntered: (json['qtyEntered'] as num).toDouble(),
    quantity: json['quantity'] as String,
    weight1: json['weight1'] as String,
  );
}

Map<String, dynamic> _$ShipmentTemporarryToJson(ShipmentTemporarry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'TRM_M_CONT_ID': instance.container,
      'containerNo': instance.containerNo,
      'weight1': instance.weight1,
      'quantity': instance.quantity,
      'Tare_Weight': instance.Tare_Weight,
      'qtyEntered': instance.qtyEntered,
    };
