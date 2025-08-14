// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generatetoolstrf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateData _$GenerateDataFromJson(Map<String, dynamic> json) {
  return GenerateData(
    orgID: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    documentNo: json['documentNo'] as String,
    dateDoc: json['dateDoc'] as String,
    doctype: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    locatorFrom: json['M_Locator_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    locatorToInTransit: json['M_Locator_New_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_New_ID'] as Map<String, dynamic>),
    toolRequest: json['BHP_ToolRequest_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ToolRequest_ID'] as Map<String, dynamic>),
    docStatus: json['docStatus'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['docStatus'] as Map<String, dynamic>),
    detail: (json['detail'] as List)
        .whereType<Map<String, dynamic>>() // Filters out null values
        .map((e) => GenerateDataLine.fromJson(e))
        .toList(),
  );
}

Map<String, dynamic> _$GenerateDataToJson(GenerateData instance) {
  final val = <String, dynamic>{
    'AD_Org_ID': instance.orgID,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('documentNo', instance.documentNo);
  val['dateDoc'] = instance.dateDoc;
  val['C_DocType_ID'] = instance.doctype;
  val['M_Locator_ID'] = instance.locatorFrom;
  val['M_Locator_New_ID'] = instance.locatorToInTransit;
  val['BHP_ToolRequest_ID'] = instance.toolRequest;
  val['docStatus'] = instance.docStatus;
  val['detail'] = instance.detail;
  return val;
}
