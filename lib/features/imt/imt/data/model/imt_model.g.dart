// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImtModel _$ImtModelFromJson(Map<String, dynamic> json) {
  return ImtModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    description: json['description'] as String,
    poReference: json['POReference'] as String,
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
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['SalesRep_ID'] as Map<String, dynamic>),
    docType: json['C_DocType_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_DocType_ID'] as Map<String, dynamic>),
    lines: (json['move-line'] as List?)
        ?.where((e) => e != null) // Memfilter elemen null dari list
        .map((e) => ImtLineEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    docAction: json['doc-action'] as String,
    isMobileTrx: json['isMobileTrx'] as bool,
    orderMovement: json['BHP_RMovement_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['BHP_RMovement_ID'] as Map<String, dynamic>),
  )..documentNo = json['documentNo'] as String;
}

Map<String, dynamic> _$ImtModelToJson(ImtModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client?.toJson());
  writeNotNull('AD_Org_ID', instance.organization?.toJson());
  writeNotNull('documentNo', instance.documentNo);
  writeNotNull('description', instance.description);
  val['POReference'] = instance.poReference;
  val['movementDate'] = instance.movementDate;
  val['BHP_RMovement_ID'] = instance.orderMovement?.toJson();
  val['M_Shipper_ID'] = instance.shipper?.toJson();
  val['priorityRule'] = instance.priorityRule?.toJson();
  writeNotNull('deliveryViaRule', instance.deliveryViaRule?.toJson());
  writeNotNull('deliveryRule', instance.deliveryRule?.toJson());
  val['M_Warehouse_ID'] = instance.warehouse?.toJson();
  val['M_WarehouseTo_ID'] = instance.warehouseTo?.toJson();
  val['AD_OrgTrx_ID'] = instance.orgTrx?.toJson();
  val['User1_ID'] = instance.user1?.toJson();
  val['C_DocType_ID'] = instance.docType?.toJson();
  val['move-line'] = instance.lines?.map((e) => e?.toJson())?.toList();
  val['doc-action'] = instance.docAction;
  val['SalesRep_ID'] = instance.salesRepresentative?.toJson();
  val['isMobileTrx'] = instance.isMobileTrx;
  return val;
}
