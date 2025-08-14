// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetauditput.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAuditPut _$AssetAuditPutFromJson(Map<String, dynamic> json) {
  return AssetAuditPut(
    auditStatus: json['Audit_Asset_Status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['Audit_Asset_Status'] as Map<String, dynamic>),
    headerID: json['BHP_AssetAudit_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_AssetAudit_ID'] as Map<String, dynamic>),
    note: json['note'] as String,
    qtyCount: json['qtyCount'] as num,
    isAudited: json['isAudited'] as bool,
    org: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    asset: json['A_Asset_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['A_Asset_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AssetAuditPutToJson(AssetAuditPut instance) =>
    <String, dynamic>{
      'AD_Org_ID': instance.org,
      'Audit_Asset_Status': instance.auditStatus,
      'A_Asset_ID': instance.asset,
      'BHP_AssetAudit_ID': instance.headerID,
      'qtyCount': instance.qtyCount,
      'note': instance.note,
      'isAudited': instance.isAudited,
    };
