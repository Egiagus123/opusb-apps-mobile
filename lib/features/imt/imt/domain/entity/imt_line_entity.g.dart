// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imt_line_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImtLineEntity _$ImtLineEntityFromJson(Map<String, dynamic> json) {
  return ImtLineEntity(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    line: json['line'] as int,
    product: json['M_Product_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_Product_ID'] as Map<String, dynamic>),
    uom: json['C_UOM_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['C_UOM_ID'] as Map<String, dynamic>),
    qtyEntered: (json['qtyEntered'] as num)!.toDouble(),
    movementQty: (json['movementQty'] as num)!.toDouble(),
    omLine: json['BHP_RMovementLine_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['BHP_RMovementLine_ID'] as Map<String, dynamic>),
    attributeSetInstance: json['M_AttributeSetInstance_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
    locator: json['M_Locator_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Locator_ID'] as Map<String, dynamic>),
    locatorTo: json['M_LocatorTo_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_LocatorTo_ID'] as Map<String, dynamic>),
  )..quantity = (json['quantity'] as num)!.toDouble();
}

Map<String, dynamic> _$ImtLineEntityToJson(ImtLineEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client);
  writeNotNull('AD_Org_ID', instance.organization);
  val['line'] = instance.line;
  val['M_Product_ID'] = instance.product;
  val['BHP_RMovementLine_ID'] = instance.omLine;
  val['C_UOM_ID'] = instance.uom;
  val['qtyEntered'] = instance.qtyEntered;
  val['movementQty'] = instance.movementQty;
  val['M_Locator_ID'] = instance.locator;
  val['M_LocatorTo_ID'] = instance.locatorTo;
  val['M_AttributeSetInstance_ID'] = instance.attributeSetInstance;
  val['quantity'] = instance.quantity;
  return val;
}
