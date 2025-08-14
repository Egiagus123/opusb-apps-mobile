// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currentdisplaymeter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentDisplayMeter _$CurrentDisplayMeterFromJson(Map<String, dynamic> json) {
  return CurrentDisplayMeter(
    bhpMInstallBaseID: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    documentDate: json['documentDate'] as String,
    bhpMeterReadingID: json['BHP_MeterReading_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_MeterReading_ID'] as Map<String, dynamic>),
    qty: (json['qty'] as num)!.toDouble(),
    meterType: json['Meter_Type'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['Meter_Type'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CurrentDisplayMeterToJson(
        CurrentDisplayMeter instance) =>
    <String, dynamic>{
      'documentDate': instance.documentDate,
      'qty': instance.qty,
      'BHP_M_InstallBase_ID': instance.bhpMInstallBaseID,
      'BHP_MeterReading_ID': instance.bhpMeterReadingID,
      'Meter_Type': instance.meterType,
    };
