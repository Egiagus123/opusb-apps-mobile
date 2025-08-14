// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetrequestline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetRequestLine _$AssetRequestLineFromJson(Map<String, dynamic> json) {
  return AssetRequestLine(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Client_ID'] as Map<String, dynamic>),
    installbase: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    toolReqID: json['BHP_ToolRequest_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ToolRequest_ID'] as Map<String, dynamic>),
    qtyDelivered: json['qtyDelivered'] as num,
    qtyEntered: json['qtyEntered'] as num,
    qtyReceipt: json['qtyReceipt'] as num,
    org: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    serNo: json['serNo'] as String,
    isSerNo: false,
    selected: false,
  );
}

Map<String, dynamic> _$AssetRequestLineToJson(AssetRequestLine instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client);
  writeNotNull('AD_Org_ID', instance.org);
  writeNotNull('BHP_ToolRequest_ID', instance.toolReqID);
  writeNotNull('qtyEntered', instance.qtyEntered);
  writeNotNull('qtyDelivered', instance.qtyDelivered);
  writeNotNull('qtyReceipt', instance.qtyReceipt);
  writeNotNull('BHP_M_InstallBase_ID', instance.installbase);
  writeNotNull('serNo', instance.serNo);
  return val;
}
