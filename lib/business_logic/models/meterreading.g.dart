// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meterreading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeterReading _$MeterReadingFromJson(Map<String, dynamic> json) {
  return MeterReading(
    id: json['id'] as int? ?? 0,
    created: json['created'] as String? ?? "",
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    createdBy: json['createdBy'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['createdBy'] as Map<String, dynamic>),
    bHPMInstallBaseID: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MeterReadingToJson(MeterReading instance) =>
    <String, dynamic>{
      'BHP_M_InstallBase_ID': instance.bHPMInstallBaseID,
      'C_DocType_ID': instance.cDoctypeid,
      'id': instance.id,
      'created': instance.created,
      'createdBy': instance.createdBy,
    };
