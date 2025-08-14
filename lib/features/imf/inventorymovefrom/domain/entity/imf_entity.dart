import 'package:json_annotation/json_annotation.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';

class ImfEntity extends BaseEntity {
  @JsonKey(nullable: true, includeIfNull: false)
  String? documentNo;

  final String? description;

  @JsonKey(name: 'POReference')
  final String? poReference;

  final String? movementDate;

  @JsonKey(name: 'BHP_RMovement_ID')
  ReferenceEntity? orderMovement;

  @JsonKey(name: 'M_Shipper_ID')
  final ReferenceEntity? shipper;

  final ReferenceEntity? priorityRule;
  final ReferenceEntity? deliveryViaRule;
  final ReferenceEntity? deliveryRule;

  @JsonKey(name: 'M_Warehouse_ID')
  ReferenceEntity? warehouse;

  @JsonKey(name: 'M_WarehouseTo_ID')
  final ReferenceEntity? warehouseTo;

  @JsonKey(name: 'SalesRep_ID')
  final ReferenceEntity? salesRepresentative;

  @JsonKey(name: 'AD_OrgTrx_ID')
  final ReferenceEntity? orgTrx;

  @JsonKey(name: 'User1_ID')
  final ReferenceEntity? user1;

  @JsonKey(name: 'C_Project_ID')
  final ReferenceEntity? project;

  @JsonKey(name: 'C_DocType_ID')
  ReferenceEntity? docType;

  @JsonKey(name: 'move-line')
  List<ImfLineEntity>? lines;

  @JsonKey(name: 'doc-action')
  String? docAction;

  @JsonKey(name: 'isMobileTrx')
  bool? isMobileTrx;

  ImfEntity(
      {int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      this.docType,
      this.warehouseTo,
      this.warehouse,
      this.movementDate,
      this.orderMovement,
      this.description = '',
      this.poReference = '',
      this.shipper,
      this.priorityRule,
      this.deliveryRule,
      this.deliveryViaRule,
      this.salesRepresentative,
      this.orgTrx,
      this.user1,
      this.project,
      this.lines,
      this.docAction = 'CO',
      this.isMobileTrx = true})
      : super(id: id!, client: client!, organization: organization!);
}
