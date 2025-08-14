// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assettrf_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTrfData _$AssetTrfDataFromJson(Map<String, dynamic> json) {
  return AssetTrfData(
    warehouse: json['warehouse'] as String,
    trfby: json['trfby'] as String,
    prodname: json['prodname'] as String,
    qty: json['qty'] as String,
    uom: json['uom'] as String,
  );
}

Map<String, dynamic> _$AssetTrfDataToJson(AssetTrfData instance) =>
    <String, dynamic>{
      'warehouse': instance.warehouse,
      'trfby': instance.trfby,
      'prodname': instance.prodname,
      'qty': instance.qty,
      'uom': instance.uom,
    };
