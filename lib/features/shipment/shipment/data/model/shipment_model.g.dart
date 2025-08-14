// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentModel _$ShipmentModelFromJson(Map<String, dynamic> json) {
  return ShipmentModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    order: json['C_Order_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['C_Order_ID'] as Map<String, dynamic>),
    docType: json['C_DocType_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_DocType_ID'] as Map<String, dynamic>),
    businessPartner: json['C_BPartner_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_BPartner_ID'] as Map<String, dynamic>),
    businessPartnerLocation: json['C_BPartner_Location_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_BPartner_Location_ID'] as Map<String, dynamic>),
    warehouse: json['M_Warehouse_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Warehouse_ID'] as Map<String, dynamic>),
    movementType: json['movementType'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['movementType'] as Map<String, dynamic>),
    deliveryRule: json['deliveryRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['deliveryRule'] as Map<String, dynamic>),
    deliveryViaRule: json['deliveryViaRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['deliveryViaRule'] as Map<String, dynamic>),
    priorityRule: json['priorityRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['priorityRule'] as Map<String, dynamic>),
    freightAmt: json['freightAmt'] as String,
    freightCostRule: json['freightCostRule'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['freightCostRule'] as Map<String, dynamic>),
    isDropShip: json['isDropShip'] as bool,
    salesRepresentative: json['SalesRep_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['SalesRep_ID'] as Map<String, dynamic>),
    orgTrx: json['AD_OrgTrx_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_OrgTrx_ID'] as Map<String, dynamic>),
    user1: json['User1_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['User1_ID'] as Map<String, dynamic>),
    user2: json['User2_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['User2_ID'] as Map<String, dynamic>),
    project: json['C_Project_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_Project_ID'] as Map<String, dynamic>),
    activity: json['C_Activity_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_Activity_ID'] as Map<String, dynamic>),
    campaign: json['C_Campaign_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_Campaign_ID'] as Map<String, dynamic>),
    shipper: json['M_Shipper_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Shipper_ID'] as Map<String, dynamic>),
    lines: (json['shipment-line'] as List)
        .where((e) => e != null)
        .map((e) => ShipmentLineEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    docAction: json['doc-action'] as String,
    isMobileTrx: json['isMobileTrx'] as bool,
  )..documentNo = json['documentNo'] as String;
}

Map<String, dynamic> _$ShipmentModelToJson(ShipmentModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client.toJson());
  writeNotNull('AD_Org_ID', instance.organization.toJson());
  val['C_Order_ID'] = instance.order!.toJson();
  writeNotNull('documentNo', instance.documentNo);
  val['C_DocType_ID'] = instance.docType!.toJson();
  val['C_BPartner_ID'] = instance.businessPartner!.toJson();
  val['C_BPartner_Location_ID'] = instance.businessPartnerLocation!.toJson();
  val['M_Warehouse_ID'] = instance.warehouse!.toJson();
  val['movementType'] = instance.movementType!.toJson();
  val['deliveryRule'] = instance.deliveryRule!.toJson();
  val['deliveryViaRule'] = instance.deliveryViaRule!.toJson();
  val['priorityRule'] = instance.priorityRule!.toJson();
  val['freightCostRule'] = instance.freightCostRule!.toJson();
  val['freightAmt'] = instance.freightAmt;
  val['isDropShip'] = instance.isDropShip;
  val['SalesRep_ID'] = instance.salesRepresentative!.toJson();
  val['AD_OrgTrx_ID'] = instance.orgTrx!.toJson();
  val['User1_ID'] = instance.user1!.toJson();
  val['User2_ID'] = instance.user2!.toJson();
  val['C_Project_ID'] = instance.project!.toJson();
  val['C_Activity_ID'] = instance.activity!.toJson();
  val['C_Campaign_ID'] = instance.campaign!.toJson();
  val['M_Shipper_ID'] = instance.shipper!.toJson();
  val['shipment-line'] = instance.lines!.map((e) => e.toJson()).toList();
  val['doc-action'] = instance.docAction;
  val['isMobileTrx'] = instance.isMobileTrx;
  return val;
}
