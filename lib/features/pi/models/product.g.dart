// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['M_Product_ID'] as int,
    value: json['value'] as String,
    name: json['name'] as String,
    sku: json['sku'] as String,
    upc: json['upc'] as String,
    uom: json['C_UOM_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_UOM_ID'] as Map<String, dynamic>),
    isLot: json['isLot'] as bool,
    isSerNo: json['isSerNo'] as bool,
    isGuaranteeDate: json['isGuaranteeDate'] as bool,
    isLotMandatory: json['isLotMandatory'] as bool,
    isSerNoMandatory: json['isSerNoMandatory'] as bool,
    isGuaranteeDateMandatory: json['isGuaranteeDateMandatory'] as bool,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'M_Product_ID': instance.id,
      'value': instance.value,
      'name': instance.name,
      'sku': instance.sku,
      'upc': instance.upc,
      'C_UOM_ID': instance.uom,
      'isLot': instance.isLot,
      'isSerNo': instance.isSerNo,
      'isGuaranteeDate': instance.isGuaranteeDate,
      'isLotMandatory': instance.isLotMandatory,
      'isSerNoMandatory': instance.isSerNoMandatory,
      'isGuaranteeDateMandatory': instance.isGuaranteeDateMandatory,
    };
