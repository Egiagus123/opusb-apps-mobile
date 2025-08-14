// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imf_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImfLineModel _$ImfLineModelFromJson(Map<String, dynamic> json) {
  return ImfLineModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    product: json['M_Product_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_Product_ID'] as Map<String, dynamic>),
    uom: json['C_UOM_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['C_UOM_ID'] as Map<String, dynamic>),
    qtyEntered: (json['qtyEntered'] as num)?.toDouble(),
    movementQty: (json['movementQty'] as num)?.toDouble(),
    locator: json['M_Locator_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Locator_ID'] as Map<String, dynamic>),
    locatorTo: json['M_LocatorTo_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_LocatorTo_ID'] as Map<String, dynamic>),
    omLine: json['BHP_RMovementLine_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['BHP_RMovementLine_ID'] as Map<String, dynamic>),
    attributeSetInstance: json['M_AttributeSetInstance_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
  )
    ..line = json['line'] as int
    ..quantity = (json['quantity'] as num).toDouble()
    ..devided = (json['devided'] as num).toDouble();
}

Map<String, dynamic> _$ImfLineModelToJson(ImfLineModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client?.toJson());
  writeNotNull('AD_Org_ID', instance.organization?.toJson());
  val['line'] = instance.line;
  val['M_Product_ID'] = instance.product?.toJson();
  val['BHP_RMovementLine_ID'] = instance.omLine?.toJson();
  val['C_UOM_ID'] = instance.uom?.toJson();
  val['qtyEntered'] = instance.qtyEntered;
  val['movementQty'] = instance.movementQty;
  val['M_Locator_ID'] = instance.locator?.toJson();
  val['M_LocatorTo_ID'] = instance.locatorTo?.toJson();
  val['M_AttributeSetInstance_ID'] = instance.attributeSetInstance?.toJson();
  val['quantity'] = instance.quantity;
  val['devided'] = instance.devided;
  return val;
}
