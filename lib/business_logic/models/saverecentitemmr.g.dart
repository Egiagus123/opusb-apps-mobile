// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saverecentitemmr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveRecentItemMR _$SaveRecentItemMRFromJson(Map<String, dynamic> json) {
  return SaveRecentItemMR(
    name: json['name'] as String,
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    bHPmeterreadingID: json['BHP_MeterReading_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_MeterReading_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SaveRecentItemMRToJson(SaveRecentItemMR instance) =>
    <String, dynamic>{
      'C_DocType_ID': instance.cDoctypeid,
      'name': instance.name,
      'BHP_MeterReading_ID': instance.bHPmeterreadingID,
    };
