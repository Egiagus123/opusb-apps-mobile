// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savemeterreading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveMeterReading _$SaveMeterReadingFromJson(Map<String, dynamic> json) {
  return SaveMeterReading(
    documentDate: json['documentDate'] as String,
    bhpinstallbaseid: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    meterType: json['meterType'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['meterType'] as Map<String, dynamic>),
    qty: (json['qty'] as num)!.toDouble(),
    adOrgID: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SaveMeterReadingToJson(SaveMeterReading instance) =>
    <String, dynamic>{
      'documentDate': instance.documentDate,
      'C_DocType_ID': instance.cDoctypeid,
      'BHP_M_InstallBase_ID': instance.bhpinstallbaseid,
      'meterType': instance.meterType,
      'adOrgID': instance.adOrgID,
      'qty': instance.qty,
    };
