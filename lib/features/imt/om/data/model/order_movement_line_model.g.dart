// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_movement_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMovementLineModel _$OrderMovementLineModelFromJson(
    Map<String, dynamic> json) {
  return OrderMovementLineModel(
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
    movementQty: (json['movementQty'] as num).toDouble(),
    qtyDelivered: (json['qtyDelivered'] as num).toDouble(),
    qtyReceipt: (json['qtyReceipt'] as num)!.toDouble(),
    qtyEntered: (json['qtyEntered'] as num)!.toDouble(),
    attributeSet: json['M_AttributeSet_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_AttributeSet_ID'] as Map<String, dynamic>),
    attributeSetInstance: json['M_AttributeSetInstance_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
    isSerNo: json['isSerNo'] as bool,
    isLot: json['isLot'] as bool,
    isGuaranteeDate: json['isGuaranteeDate'] as bool,
    isGuaranteeDateMandatory: json['isGuaranteeDateMandatory'] as bool,
    isLotMandatory: json['isLotMandatory'] as bool,
    isSerNoMandatory: json['isSerNoMandatory'] as bool,
  )..productCategory = json['M_Product_Category_ID'] == null
      ? ReferenceEntity.defaultReference()
      : ReferenceEntity.fromJson(
          json['M_Product_Category_ID'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderMovementLineModelToJson(
    OrderMovementLineModel instance) {
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
  val['C_UOM_ID'] = instance.uom?.toJson();
  val['movementQty'] = instance.movementQty;
  val['qtyReceipt'] = instance.qtyReceipt;
  val['qtyDelivered'] = instance.qtyDelivered;
  val['qtyEntered'] = instance.qtyEntered;
  val['M_AttributeSet_ID'] = instance.attributeSet?.toJson();
  val['M_AttributeSetInstance_ID'] = instance.attributeSetInstance?.toJson();
  val['isLot'] = instance.isLot;
  val['isLotMandatory'] = instance.isLotMandatory;
  val['isSerNo'] = instance.isSerNo;
  val['isSerNoMandatory'] = instance.isSerNoMandatory;
  val['isGuaranteeDate'] = instance.isGuaranteeDate;
  val['isGuaranteeDateMandatory'] = instance.isGuaranteeDateMandatory;
  val['M_Product_Category_ID'] = instance.productCategory?.toJson();
  return val;
}
