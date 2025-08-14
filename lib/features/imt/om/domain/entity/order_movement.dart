import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class OrderMovement extends BaseEntity {
  final String? documentNo;
  final String? description;
  final String? poReference;
  final String? movementDate;

  @JsonKey(name: 'M_Shipper_ID')
  final ReferenceEntity? shipper;

  final ReferenceEntity? priorityRule;
  final ReferenceEntity? deliveryViaRule;
  final ReferenceEntity? deliveryRule;

  @JsonKey(name: 'M_Warehouse_ID')
  final ReferenceEntity warehouse;

  @JsonKey(name: 'M_WarehouseTo_ID')
  final ReferenceEntity warehouseTo;

  @JsonKey(name: 'AD_OrgTrx_ID')
  final ReferenceEntity? orgTrx;

  @JsonKey(name: 'User1_ID')
  final ReferenceEntity? user1;

  @JsonKey(name: 'C_Project_ID')
  final ReferenceEntity? project;

  @JsonKey(name: 'SalesRep_ID')
  final ReferenceEntity? salesRepresentative;

  final ReferenceEntity docStatus;

  @JsonKey(name: 'C_DocType_ID')
  final ReferenceEntity docType;

  OrderMovement({
    required int id,
    required ReferenceEntity client,
    required ReferenceEntity organization,
    required this.documentNo,
    required this.docStatus,
    required this.docType,
    required this.movementDate,
    required this.warehouse,
    required this.warehouseTo,
    this.description,
    this.poReference,
    this.shipper,
    this.priorityRule,
    this.deliveryViaRule,
    this.deliveryRule,
    this.orgTrx,
    this.user1,
    this.project,
    this.salesRepresentative,
  }) : super(id: id, client: client, organization: organization);
}
