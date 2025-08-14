// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recentitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentItem _$RecentItemFromJson(Map<String, dynamic> json) {
  return RecentItem(
    name: json['name'] as String,
    created: json['created'] as String,
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    createdBy: json['createdBy'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['createdBy'] as Map<String, dynamic>),
    bhpwoserviceid: json['BHP_WOService_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_WOService_ID'] as Map<String, dynamic>),
    bhpmeterreadingid: json['BHP_MeterReading_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_MeterReading_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecentItemToJson(RecentItem instance) =>
    <String, dynamic>{
      'BHP_WOService_ID': instance.bhpwoserviceid,
      'BHP_MeterReading_ID': instance.bhpmeterreadingid,
      'C_DocType_ID': instance.cDoctypeid,
      'name': instance.name,
      'created': instance.created,
      'createdBy': instance.createdBy,
    };
