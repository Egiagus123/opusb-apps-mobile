// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetauditheader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAuditHeader _$AssetAuditHeaderFromJson(Map<String, dynamic> json) {
  return AssetAuditHeader(
    id: json['id'] as int,
    documentNo: json['documentNo'] as String,
    date1: json['date1'] as String,
    docType: json['C_DocType_ID'] == null
        ? Reference
            .defaultReference() // Replace with an appropriate default constructor
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    locator: json['M_Locator_ID'] == null
        ? Reference
            .defaultReference() // Replace with an appropriate default constructor
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    docStatus: json['docStatus'] == null
        ? Reference
            .defaultReference() // Replace with an appropriate default constructor
        : Reference.fromJson(json['docStatus'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AssetAuditHeaderToJson(AssetAuditHeader instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentNo': instance.documentNo,
      'date1': instance.date1,
      'C_DocType_ID': instance.docType,
      'M_Locator_ID': instance.locator,
      'docStatus': instance.docStatus,
    };
