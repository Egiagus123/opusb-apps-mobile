import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/util/common_generator.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';

part 'receipt_line_entity.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class ReceiptLineEntity extends BaseEntity {
  @JsonKey(ignore: true)
  String localUuid = generateUuidV4();

  int? line;

  @JsonKey(ignore: true)
  bool? selected;

  @JsonKey(ignore: true)
  ReferenceEntity? product;

  @JsonKey(ignore: true)
  OrderLine? orderLine;

  @JsonKey(name: 'C_OrderLine_ID')
  ReferenceEntity? poLine;

  @JsonKey(name: 'M_Warehouse_ID')
  ReferenceEntity? warehouse;

  @JsonKey(name: 'M_Locator_ID')
  ReferenceEntity? locator;

  @JsonKey(name: 'C_UOM_ID')
  ReferenceEntity? uom;

  @JsonKey(name: 'AD_OrgTrx_ID')
  ReferenceEntity? orgTrxId;

  @JsonKey(name: 'User1_ID')
  ReferenceEntity? user1;

  @JsonKey(name: 'User2_ID', includeIfNull: true)
  ReferenceEntity? user2;

  @JsonKey(name: 'C_Project_ID', includeIfNull: true)
  ReferenceEntity? project;

  @JsonKey(name: 'C_ProjectPhase_ID', includeIfNull: true)
  ReferenceEntity? projectPhase;

  @JsonKey(name: 'C_ProjectTask_ID', includeIfNull: true)
  ReferenceEntity? projectTask;

  @JsonKey(name: 'C_Activity_ID', includeIfNull: true)
  ReferenceEntity? activity;

  @JsonKey(name: 'C_Campaign_ID', includeIfNull: true)
  ReferenceEntity? campaign;

  /// These properties (movementQty and qtyEntered) are used to update
  /// the receipt quantity.
  double? movementQty;
  double? qtyEntered;

  @JsonKey(name: 'M_AttributeSet_ID')
  ReferenceEntity? attributeSet;

  @JsonKey(name: 'M_AttributeSetInstance_ID')
  ReferenceEntity? attributeSetInstance;

  bool? isLot;
  bool? isLotMandatory;
  bool? isSerNo;
  bool? isSerNoMandatory;
  bool isGuaranteeDate;
  bool? isGuaranteeDateMandatory;

  @JsonKey(ignore: true)
  AttributeSetInstance? asi;

  @JsonKey(ignore: true)
  String? attributeNo;

  ReceiptLineEntity(
      {int? id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      this.line = 0,
      this.selected = false,
      this.product,
      this.orderLine,
      @required this.poLine,
      @required this.warehouse,
      @required this.locator,
      @required this.uom,
      @required this.orgTrxId,
      @required this.user1,
      this.user2,
      this.project,
      this.projectPhase,
      this.projectTask,
      this.activity,
      this.campaign,
      this.movementQty,
      this.qtyEntered,
      required this.attributeSet,
      this.attributeSetInstance,
      required this.isLot,
      required this.isLotMandatory,
      required this.isSerNo,
      required this.isSerNoMandatory,
      required this.isGuaranteeDate,
      required this.isGuaranteeDateMandatory})
      : super(id: id!, client: client, organization: organization);

  factory ReceiptLineEntity.fromJson(Map<String, dynamic> json) =>
      _$ReceiptLineEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptLineEntityToJson(this);

  /// Set the entered and movement quantity properties.
  set quantity(double value) {
    qtyEntered = value;
    final poQtyEntered = orderLine!.qtyEntered;
    final poQtyOrdered = orderLine!.qtyOrdered;

    if (poQtyEntered == poQtyOrdered) {
      movementQty = qtyEntered;
    } else {
      double uomRatio = poQtyOrdered / poQtyEntered;
      movementQty = (uomRatio * value).floorToDouble();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is ReceiptLineEntity &&
          localUuid == other.localUuid;

  @override
  int get hashCode => runtimeType.hashCode ^ localUuid.hashCode;
}
