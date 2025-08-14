// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generatetoolstrfline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateDataLine _$GenerateDataLineFromJson(Map<String, dynamic> json) {
  return GenerateDataLine(
    orgID: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    serNo: json['serNo'] as String,
    installBase: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    qtyEntered: json['qtyEntered'] as num,
    toolRequestLineID: json['BHP_ToolRequestLine_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ToolRequestLine_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GenerateDataLineToJson(GenerateDataLine instance) =>
    <String, dynamic>{
      'AD_Org_ID': instance.orgID,
      'serNo': instance.serNo,
      'BHP_M_InstallBase_ID': instance.installBase,
      'BHP_ToolRequestLine_ID': instance.toolRequestLineID,
      'qtyEntered': instance.qtyEntered,
    };
