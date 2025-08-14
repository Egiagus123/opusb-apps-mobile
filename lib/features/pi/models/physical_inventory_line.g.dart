// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_inventory_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalInventoryLine _$PhysicalInventoryLineFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['qtyCount']);
  return PhysicalInventoryLine(
    id: json['id'] as int,
    inventory: json['M_Inventory_ID'] == null
        ? null
        : Reference.fromJson(json['M_Inventory_ID'] as Map<String, dynamic>),
    locator: json['M_Locator_ID'] == null
        ? null
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    product: json['M_Product_ID'] == null
        ? null
        : Reference.fromJson(json['M_Product_ID'] as Map<String, dynamic>),
    asi: json['M_AttributeSetInstance_ID'] == null
        ? null
        : Reference.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
    uom: json['C_UOM_ID'] == null
        ? null
        : Reference.fromJson(json['C_UOM_ID'] as Map<String, dynamic>),
    description: json['description'] as String,
    qtyBook: json['qtyBook'] as num,
    qtyCount: json['qtyCount'] as num,
    productValue: json['productValue'] as String,
    productName: json['productName'] as String,
    upc: json['upc'] as String,
    lot: json['lot'] as String,
    serNo: json['serNo'] as String,
    isLot: json['isLot'] as bool,
    isSerNo: json['isSerNo'] as bool,
    isLotMandatory: json['isLotMandatory'] as bool,
    isSerNoMandatory: json['isSerNoMandatory'] as bool,
    isInDispute: json['isInDispute'] as bool,
    isChecked: json['isChecked'] as bool,
  );
}

Map<String, dynamic> _$PhysicalInventoryLineToJson(
    PhysicalInventoryLine instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('M_Inventory_ID', instance.inventory);
  writeNotNull('M_Locator_ID', instance.locator);
  writeNotNull('M_Product_ID', instance.product);
  writeNotNull('M_AttributeSetInstance_ID', instance.asi);
  writeNotNull('C_UOM_ID', instance.uom);
  writeNotNull('description', instance.description);
  writeNotNull('qtyCount', instance.qtyCount);
  writeNotNull('qtyBook', toNull(instance.qtyBook));
  writeNotNull('productValue', toNull(instance.productValue));
  writeNotNull('productName', toNull(instance.productName));
  writeNotNull('upc', toNull(instance.upc));
  writeNotNull('lot', toNull(instance.lot));
  writeNotNull('serNo', toNull(instance.serNo));
  writeNotNull('isLot', toNull(instance.isLot));
  writeNotNull('isSerNo', toNull(instance.isSerNo));
  writeNotNull('isLotMandatory', toNull(instance.isLotMandatory));
  writeNotNull('isSerNoMandatory', toNull(instance.isSerNoMandatory));
  writeNotNull('isInDispute', toNull(instance.isInDispute));
  writeNotNull('isChecked', instance.isChecked);
  return val;
}
