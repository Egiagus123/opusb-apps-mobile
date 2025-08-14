// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageEquipment _$ImageEquipmentFromJson(Map<String, dynamic> json) {
  return ImageEquipment(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Client_ID'] as Map<String, dynamic>),
    org: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    binaryData: json['binaryData'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ImageEquipmentToJson(ImageEquipment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'AD_Client_ID': instance.client,
      'AD_Org_ID': instance.org,
      'binaryData': instance.binaryData,
      'name': instance.name,
    };
