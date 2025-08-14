// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saverecentitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveRecentItem _$SaveRecentItemFromJson(Map<String, dynamic> json) {
  return SaveRecentItem(
    documentNo: json['documentNo'] as String,
    name: json['name'] as String,
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    bHPWOServiceID: json['BHP_WOService_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_WOService_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SaveRecentItemToJson(SaveRecentItem instance) =>
    <String, dynamic>{
      'documentNo': instance.documentNo,
      'C_DocType_ID': instance.cDoctypeid,
      'name': instance.name,
      'BHP_WOService_ID': instance.bHPWOServiceID,
    };
