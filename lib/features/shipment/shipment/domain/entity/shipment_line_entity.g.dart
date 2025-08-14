// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_line_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentLineEntity _$ShipmentLineEntityFromJson(Map<String, dynamic> json) {
  return ShipmentLineEntity(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    line: json['line'] as int,
    poLine: json['C_OrderLine_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_OrderLine_ID'] as Map<String, dynamic>),
    warehouse: json['M_Warehouse_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Warehouse_ID'] as Map<String, dynamic>),
    locator: json['M_Locator_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_Locator_ID'] as Map<String, dynamic>),
    uom: json['C_UOM_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['C_UOM_ID'] as Map<String, dynamic>),
    orgTrxId: json['AD_OrgTrx_ID'] == null
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
    projectPhase: json['C_ProjectPhase_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_ProjectPhase_ID'] as Map<String, dynamic>),
    projectTask: json['C_ProjectTask_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_ProjectTask_ID'] as Map<String, dynamic>),
    activity: json['C_Activity_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_Activity_ID'] as Map<String, dynamic>),
    campaign: json['C_Campaign_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['C_Campaign_ID'] as Map<String, dynamic>),
    movementQty: (json['movementQty'] as num)?.toDouble(),
    qtyEntered: (json['qtyEntered'] as num)?.toDouble(),
    attributeSet: json['M_AttributeSet_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_AttributeSet_ID'] as Map<String, dynamic>),
    attributeSetInstance: json['M_AttributeSetInstance_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
    isLot: json['isLot'] as bool,
    isLotMandatory: json['isLotMandatory'] as bool,
    isSerNo: json['isSerNo'] as bool,
    isSerNoMandatory: json['isSerNoMandatory'] as bool,
    isGuaranteeDate: json['isGuaranteeDate'] as bool,
    isGuaranteeDateMandatory: json['isGuaranteeDateMandatory'] as bool,
  );
}

Map<String, dynamic> _$ShipmentLineEntityToJson(ShipmentLineEntity instance) {
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
  val['C_OrderLine_ID'] = instance.poLine;
  val['M_Warehouse_ID'] = instance.warehouse;
  val['M_Locator_ID'] = instance.locator;
  val['C_UOM_ID'] = instance.uom;
  val['AD_OrgTrx_ID'] = instance.orgTrxId;
  val['User1_ID'] = instance.user1;
  val['User2_ID'] = instance.user2;
  val['C_Project_ID'] = instance.project;
  val['C_ProjectPhase_ID'] = instance.projectPhase;
  val['C_ProjectTask_ID'] = instance.projectTask;
  val['C_Activity_ID'] = instance.activity;
  val['C_Campaign_ID'] = instance.campaign;
  val['movementQty'] = instance.movementQty;
  val['qtyEntered'] = instance.qtyEntered;
  val['M_AttributeSet_ID'] = instance.attributeSet;
  val['M_AttributeSetInstance_ID'] = instance.attributeSetInstance;
  val['isLot'] = instance.isLot;
  val['isLotMandatory'] = instance.isLotMandatory;
  val['isSerNo'] = instance.isSerNo;
  val['isSerNoMandatory'] = instance.isSerNoMandatory;
  val['isGuaranteeDate'] = instance.isGuaranteeDate;
  val['isGuaranteeDateMandatory'] = instance.isGuaranteeDateMandatory;
  return val;
}
