import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';

class ShipmentEntity extends BaseEntity {
  @JsonKey(ignore: true)
  bool? isSoTrx;

  @JsonKey(name: 'C_Order_ID')
  ReferenceEntity? order;

  @JsonKey(nullable: true, includeIfNull: false)
  String? documentNo;

  @JsonKey(name: 'C_DocType_ID')
  ReferenceEntity? docType;

  @JsonKey(name: 'C_BPartner_ID')
  ReferenceEntity? businessPartner;

  @JsonKey(name: 'C_BPartner_Location_ID')
  ReferenceEntity? businessPartnerLocation;

  @JsonKey(name: 'M_Warehouse_ID')
  ReferenceEntity? warehouse;

  final ReferenceEntity? movementType;
  final ReferenceEntity? deliveryRule;
  final ReferenceEntity? deliveryViaRule;
  final ReferenceEntity? priorityRule;
  final ReferenceEntity? freightCostRule;
  String? freightAmt;
  bool? isDropShip;

  @JsonKey(name: 'SalesRep_ID')
  ReferenceEntity? salesRepresentative;

  @JsonKey(name: 'AD_OrgTrx_ID')
  ReferenceEntity? orgTrx;

  @JsonKey(name: 'User1_ID')
  ReferenceEntity? user1;

  @JsonKey(name: 'User2_ID', includeIfNull: true)
  ReferenceEntity? user2;

  @JsonKey(name: 'C_Project_ID', includeIfNull: true)
  ReferenceEntity? project;

  @JsonKey(name: 'C_Activity_ID', includeIfNull: true)
  ReferenceEntity? activity;

  @JsonKey(name: 'C_Campaign_ID', includeIfNull: true)
  ReferenceEntity? campaign;

  @JsonKey(name: 'M_Shipper_ID', includeIfNull: true)
  ReferenceEntity? shipper;

  @JsonKey(name: 'shipment-line')
  List<ShipmentLineEntity>? lines;

  @JsonKey(name: 'doc-action')
  String? docAction;

  @JsonKey(name: 'isMobileTrx')
  bool isMobileTrx;

  ShipmentEntity(
      {int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      this.isSoTrx = false,
      @required this.order,
      this.docType,
      @required this.businessPartner,
      @required this.businessPartnerLocation,
      @required this.warehouse,
      @required this.movementType,
      @required this.deliveryRule,
      @required this.deliveryViaRule,
      @required this.priorityRule,
      @required this.freightAmt,
      @required this.freightCostRule,
      @required this.isDropShip,
      this.salesRepresentative,
      @required this.orgTrx,
      this.user1,
      this.user2,
      this.project,
      this.activity,
      this.campaign,
      this.shipper,
      this.lines,
      this.docAction = 'CO',
      this.isMobileTrx = true})
      : super(id: id!, client: client!, organization: organization!);
}
