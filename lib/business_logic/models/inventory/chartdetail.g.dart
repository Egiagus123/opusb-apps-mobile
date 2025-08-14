// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chartdetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataDetail _$DataDetailFromJson(Map<String, dynamic> json) {
  return DataDetail(
    wostatus: json['YTDWorkOrder.wostatus'] as String,
    totalwo: json['YTDWorkOrder.totalwo'] as String,
  );
}

Map<String, dynamic> _$DataDetailToJson(DataDetail instance) =>
    <String, dynamic>{
      'YTDWorkOrder.wostatus': instance.wostatus,
      'YTDWorkOrder.totalwo': instance.totalwo,
    };
