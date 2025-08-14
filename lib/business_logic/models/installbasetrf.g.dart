// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installbasetrf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallBaseTransfer _$InstallBaseTransferFromJson(Map<String, dynamic> json) {
  return InstallBaseTransfer(
    id: json['id'] as int? ?? 0,
    tooltrfID: json['BHP_ToolTransfer_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ToolTransfer_ID'] as Map<String, dynamic>),
    installBaseID: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    dateDoc: json['dateDoc'] as String? ?? "",
    bpartnerSR: json['C_BPartnerSR_New_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['C_BPartnerSR_New_ID'] as Map<String, dynamic>),
    duration: json['duration'] as int? ?? 0,
    doctype: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    from: json['M_Locator_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    to: json['M_Locator_New_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_New_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$InstallBaseTransferToJson(
        InstallBaseTransfer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'BHP_ToolTransfer_ID': instance.tooltrfID,
      'BHP_M_InstallBase_ID': instance.installBaseID,
      'duration': instance.duration,
      'dateDoc': instance.dateDoc,
      'M_Locator_ID': instance.from,
      'M_Locator_New_ID': instance.to,
      'C_BPartnerSR_New_ID': instance.bpartnerSR,
      'C_DocType_ID': instance.doctype,
    };
