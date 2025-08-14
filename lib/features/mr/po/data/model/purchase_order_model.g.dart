// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseOrderModel _$PurchaseOrderModelFromJson(Map<String, dynamic> json) {
  return PurchaseOrderModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    documentNo: json['documentNo'] as String,
    businessPartner: json['C_BPartner_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_BPartner_ID'] as Map<String, dynamic>),
    businessPartnerLocation: json['C_BPartner_Location_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_BPartner_Location_ID'] as Map<String, dynamic>),
    docStatus: json['docStatus'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['docStatus'] as Map<String, dynamic>),
    docType: json['C_DocType_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_DocType_ID'] as Map<String, dynamic>),
    docTypeTarget: json['C_DocTypeTarget_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_DocTypeTarget_ID'] as Map<String, dynamic>),
    description: json['description'] as String,
    dateOrdered: json['dateOrdered'] as String,
    datePromised: json['datePromised'] as String,
    dateAcct: json['dateAcct'] as String,
    orgTrx: json['AD_OrgTrx_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_OrgTrx_ID'] as Map<String, dynamic>),
    user1: json['User1_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['User1_ID'] as Map<String, dynamic>),
    project: json['C_Project_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_Project_ID'] as Map<String, dynamic>),
    paymentTerm: json['C_PaymentTerm_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_PaymentTerm_ID'] as Map<String, dynamic>),
    currency: json['C_Currency_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['C_Currency_ID'] as Map<String, dynamic>),
    warehouse: json['M_Warehouse_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_Warehouse_ID'] as Map<String, dynamic>),
    chargeAmt: json['chargeAmt'] as String,
    deliveryRule: json['deliveryRule'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['deliveryRule'] as Map<String, dynamic>),
    deliveryViaRule: json['deliveryViaRule'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['deliveryViaRule'] as Map<String, dynamic>),
    freightAmt: json['freightAmt'] as String,
    freightCostRule: json['freightCostRule'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['freightCostRule'] as Map<String, dynamic>),
    paymentRule: json['paymentRule'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['paymentRule'] as Map<String, dynamic>),
    salesRepresentative: json['SalesRep_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['SalesRep_ID'] as Map<String, dynamic>),
    isDropShip: json['isDropShip'] as bool,
    isSoTrx: json['isSoTrx'] as bool,
  );
}

Map<String, dynamic> _$PurchaseOrderModelToJson(PurchaseOrderModel instance) {
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
  val['docStatus'] = instance.docStatus?.toJson();
  val['C_BPartner_ID'] = instance.businessPartner?.toJson();
  val['C_BPartner_Location_ID'] = instance.businessPartnerLocation?.toJson();
  val['C_DocType_ID'] = instance.docType?.toJson();
  val['C_DocTypeTarget_ID'] = instance.docTypeTarget?.toJson();
  val['description'] = instance.description;
  val['dateOrdered'] = instance.dateOrdered;
  val['datePromised'] = instance.datePromised;
  val['dateAcct'] = instance.dateAcct;
  val['AD_OrgTrx_ID'] = instance.orgTrx?.toJson();
  val['User1_ID'] = instance.user1?.toJson();
  val['C_Project_ID'] = instance.project?.toJson();
  val['C_PaymentTerm_ID'] = instance.paymentTerm?.toJson();
  val['C_Currency_ID'] = instance.currency?.toJson();
  val['M_Warehouse_ID'] = instance.warehouse?.toJson();
  val['chargeAmt'] = instance.chargeAmt;
  val['deliveryRule'] = instance.deliveryRule?.toJson();
  val['deliveryViaRule'] = instance.deliveryViaRule?.toJson();
  val['freightAmt'] = instance.freightAmt;
  val['freightCostRule'] = instance.freightCostRule?.toJson();
  val['paymentRule'] = instance.paymentRule?.toJson();
  val['SalesRep_ID'] = instance.salesRepresentative?.toJson();
  val['isDropShip'] = instance.isDropShip;
  val['isSoTrx'] = instance.isSoTrx;
  return val;
}
