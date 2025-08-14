// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assetrcvdata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetRcvData _$AssetRcvDataFromJson(Map<String, dynamic> json) {
  return AssetRcvData(
    id: json['id'] as int,
    agent: json['C_BPartnerSR_New_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['C_BPartnerSR_New_ID'] as Map<String, dynamic>),
    bpartner: json['C_BPartner_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_BPartner_ID'] as Map<String, dynamic>),
    businessunit: json['User1_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['User1_ID'] as Map<String, dynamic>),
    client: json['AD_Client_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Client_ID'] as Map<String, dynamic>),
    dateDoc: json['dateDoc'] as String,
    dateRequired:
        const DateTimeJsonConverter().fromJson(json['dateRequired'] as String),
    dateReceived: json['dateReceived'] as String,
    description: json['description'] as String,
    docStatus: json['docStatus'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['docStatus'] as Map<String, dynamic>),
    doctype: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    documentNo: json['documentNo'] as String,
    locator: json['M_Locator_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    locatorTo: json['M_Locator_New_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_New_ID'] as Map<String, dynamic>),
    org: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    orgTrx: json['AD_OrgTrx_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_OrgTrx_ID'] as Map<String, dynamic>),
    serNo: json['serNo'] as String,
    requestLineID: json['BHP_ToolRequestLine_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ToolRequestLine_ID'] as Map<String, dynamic>),
    qtyEntered: json['qtyEntered'] as num,
    installbase: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    intransit: json['intransit'] as int,
    trfdatedoc: json['trfdatedoc'] as String,
    trfdocno: json['trfdocno'] as String,
  );
}

Map<String, dynamic> _$AssetRcvDataToJson(AssetRcvData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'AD_Client_ID': instance.client,
      'AD_Org_ID': instance.org,
      'documentNo': instance.documentNo,
      'description': instance.description,
      'dateReceived': instance.dateReceived,
      'serNo': instance.serNo,
      'dateDoc': instance.dateDoc,
      'trfdatedoc': instance.trfdatedoc,
      'trfdocno': instance.trfdocno,
      'C_DocType_ID': instance.doctype,
      'C_BPartner_ID': instance.bpartner,
      'AD_OrgTrx_ID': instance.orgTrx,
      'User1_ID': instance.businessunit,
      'docStatus': instance.docStatus,
      'M_Locator_ID': instance.locator,
      'C_BPartnerSR_New_ID': instance.agent,
      'M_Locator_New_ID': instance.locatorTo,
      'dateRequired':
          const DateTimeJsonConverter().toJson(instance.dateRequired),
      'BHP_ToolRequestLine_ID': instance.requestLineID,
      'qtyEntered': instance.qtyEntered,
      'BHP_M_InstallBase_ID': instance.installbase,
      'intransit': instance.intransit,
    };
