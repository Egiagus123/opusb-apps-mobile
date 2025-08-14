// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltrf_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToolsTrfLine _$ToolsTrfLineFromJson(Map<String, dynamic> json) {
  return ToolsTrfLine(
    doctype: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    locator: json['M_Locator_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    locatorTo: json['M_Locator_New_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_New_ID'] as Map<String, dynamic>),
    installBase: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    qtyEntered: json['qtyEntered'] as num,
    requestID: json['BHP_ToolRequest_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ToolRequest_ID'] as Map<String, dynamic>),
    trxtype: json['M_TrxType'] as String,
    datedoc: json['datedoc'] as String,
    serNo: json['serNo'] as String,
  );
}

Map<String, dynamic> _$ToolsTrfLineToJson(ToolsTrfLine instance) =>
    <String, dynamic>{
      'C_DocType_ID': instance.doctype,
      'M_Locator_ID': instance.locator,
      'M_Locator_New_ID': instance.locatorTo,
      'BHP_M_InstallBase_ID': instance.installBase,
      'BHP_ToolRequest_ID': instance.requestID,
      'M_TrxType': instance.trxtype,
      'qtyEntered': instance.qtyEntered,
      'datedoc': instance.datedoc,
      'serNo': instance.serNo,
    };
