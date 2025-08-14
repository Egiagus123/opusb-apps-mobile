// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLineModel _$OrderLineModelFromJson(Map<String, dynamic> json) {
  return OrderLineModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    line: json['line'] as int,
    product: json['M_Product_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Product_ID'] as Map<String, dynamic>),
    uom: json['C_UOM_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['C_UOM_ID'] as Map<String, dynamic>),
    qtyOrdered: (json['qtyOrdered'] as num)?.toDouble(),
    qtyReserved: (json['qtyReserved'] as num)?.toDouble(),
    qtyDelivered: (json['qtyDelivered'] as num)?.toDouble(),
    qtyInvoiced: (json['qtyInvoiced'] as num)?.toDouble(),
    qtyEntered: (json['qtyEntered'] as num)?.toDouble(),
    processed: json['processed'] as bool,
    attributeSet: json['M_AttributeSet_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_AttributeSet_ID'] as Map<String, dynamic>),
    productName: json['product_name'] as String,
    productKey: json['product_search_key'] as String,
    productCategory: json['M_Product_Category_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Product_Category_ID'] as Map<String, dynamic>),
    isSerNo: json['isSerNo'] as bool,
    isLot: json['isLot'] as bool,
    isGuaranteeDate: json['isGuaranteeDate'] as bool,
    isGuaranteeDateMandatory: json['isGuaranteeDateMandatory'] as bool,
    isLotMandatory: json['isLotMandatory'] as bool,
    isSerNoMandatory: json['isSerNoMandatory'] as bool,
  );
}

Map<String, dynamic> _$OrderLineModelToJson(OrderLineModel instance) {
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
  val['qtyEntered'] = instance.qtyEntered;
  val['qtyOrdered'] = instance.qtyOrdered;
  val['qtyReserved'] = instance.qtyReserved;
  val['qtyDelivered'] = instance.qtyDelivered;
  val['qtyInvoiced'] = instance.qtyInvoiced;
  val['processed'] = instance.processed;
  val['product_name'] = instance.productName;
  val['product_search_key'] = instance.productKey;
  val['M_Product_Category_ID'] = instance.productCategory?.toJson();
  val['M_AttributeSet_ID'] = instance.attributeSet?.toJson();
  val['isLot'] = instance.isLot;
  val['isLotMandatory'] = instance.isLotMandatory;
  val['isSerNo'] = instance.isSerNo;
  val['isSerNoMandatory'] = instance.isSerNoMandatory;
  val['isGuaranteeDate'] = instance.isGuaranteeDate;
  val['isGuaranteeDateMandatory'] = instance.isGuaranteeDateMandatory;
  return val;
}
