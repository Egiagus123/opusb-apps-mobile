// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetauditline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetAuditLines _$AssetAuditLinesFromJson(Map<String, dynamic> json) {
  return AssetAuditLines(
    id: json['id'] as int,
    status: json['A_Asset_Status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['A_Asset_Status'] as Map<String, dynamic>),
    name: json['name'] as String,
    note: json['note'] as String,
    attributeSet: json['M_AttributeSetInstance_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
    assetActivationDate: json['assetActivationDate'] as String,
    qty: json['A_QTY_Current'] as String,
    product: json['M_Product_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Product_ID'] as Map<String, dynamic>),
    asset: json['A_Asset_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['A_Asset_ID'] as Map<String, dynamic>),
    auditStatus: json['Audit_Asset_Status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['Audit_Asset_Status'] as Map<String, dynamic>),
    idHeader: json['BHP_AssetAudit_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_AssetAudit_ID'] as Map<String, dynamic>),
    updated: const DateTimeJsonConverter().fromJson(json['updated'] as String),
    qtyCount: json['qtyCount'] as num,
    assetvalue: json['assetvalue'] as String,
    assetname: json['assetname'] as String,
    assetstatus: json['assetstatus'] as String,
  );
}

Map<String, dynamic> _$AssetAuditLinesToJson(AssetAuditLines instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'note': instance.note,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('A_Asset_Status', instance.status);
  writeNotNull('BHP_AssetAudit_ID', instance.idHeader);
  val['Audit_Asset_Status'] = instance.auditStatus;
  writeNotNull('M_AttributeSetInstance_ID', instance.attributeSet);
  val['assetActivationDate'] = instance.assetActivationDate;
  val['updated'] = const DateTimeJsonConverter().toJson(instance.updated);
  writeNotNull('A_QTY_Current', instance.qty);
  writeNotNull('M_Product_ID', instance.product);
  writeNotNull('A_Asset_ID', instance.asset);
  val['qtyCount'] = instance.qtyCount;
  val['assetvalue'] = instance.assetvalue;
  val['assetname'] = instance.assetname;
  val['assetstatus'] = instance.assetstatus;
  return val;
}
