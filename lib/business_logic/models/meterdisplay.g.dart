// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meterdisplay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeterTypeModel _$MeterTypeModelFromJson(Map<String, dynamic> json) {
  return MeterTypeModel(
    id: json['id'] as int,
    meterType: json['Meter_Type'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['Meter_Type'] as Map<String, dynamic>),
    adOrgID: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MeterTypeModelToJson(MeterTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adOrgID': instance.adOrgID,
      'meterType': instance.meterType,
    };
