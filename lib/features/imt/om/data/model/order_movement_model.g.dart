// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_movement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMovementModel _$OrderMovementModelFromJson(Map<String, dynamic> json) {
  return OrderMovementModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    documentNo: json['documentNo'] as String,
    description: json['description'] as String,
    poReference: json['poReference'] as String,
    movementDate: json['movementDate'] as String,
    shipper: json['M_Shipper_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Shipper_ID'] as Map<String, dynamic>),
    priorityRule: json['priorityRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['priorityRule'] as Map<String, dynamic>),
    deliveryViaRule: json['deliveryViaRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['deliveryViaRule'] as Map<String, dynamic>),
    deliveryRule: json['deliveryRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['deliveryRule'] as Map<String, dynamic>),
    warehouse: json['M_Warehouse_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_Warehouse_ID'] as Map<String, dynamic>),
    warehouseTo: json['M_WarehouseTo_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_WarehouseTo_ID'] as Map<String, dynamic>),
    orgTrx: json['AD_OrgTrx_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_OrgTrx_ID'] as Map<String, dynamic>),
    user1: json['User1_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['User1_ID'] as Map<String, dynamic>),
    salesRepresentative: json['SalesRep_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['SalesRep_ID'] as Map<String, dynamic>),
    project: json['C_Project_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_Project_ID'] as Map<String, dynamic>),
    docStatus: json['docStatus'] == null
        ? null
        : ReferenceEntity.fromJson(json['docStatus'] as Map<String, dynamic>),
    docType: json['C_DocType_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_DocType_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OrderMovementModelToJson(OrderMovementModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client?.toJson());
  writeNotNull('AD_Org_ID', instance.organization?.toJson());
  val['documentNo'] = instance.documentNo;
  val['description'] = instance.description;
  val['poReference'] = instance.poReference;
  val['movementDate'] = instance.movementDate;
  val['M_Shipper_ID'] = instance.shipper?.toJson();
  val['priorityRule'] = instance.priorityRule?.toJson();
  val['deliveryViaRule'] = instance.deliveryViaRule?.toJson();
  val['deliveryRule'] = instance.deliveryRule?.toJson();
  val['M_Warehouse_ID'] = instance.warehouse?.toJson();
  val['M_WarehouseTo_ID'] = instance.warehouseTo?.toJson();
  val['AD_OrgTrx_ID'] = instance.orgTrx?.toJson();
  val['User1_ID'] = instance.user1?.toJson();
  val['C_Project_ID'] = instance.project?.toJson();
  val['SalesRep_ID'] = instance.salesRepresentative?.toJson();
  val['docStatus'] = instance.docStatus?.toJson();
  val['C_DocType_ID'] = instance.docType?.toJson();
  return val;
}
