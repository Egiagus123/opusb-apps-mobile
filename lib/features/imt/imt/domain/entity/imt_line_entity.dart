import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/util/common_generator.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';

part 'imt_line_entity.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class ImtLineEntity extends BaseEntity {
  @JsonKey(ignore: true)
  String localUuid = generateUuidV4();

  int line;

  @JsonKey(ignore: true)
  bool selected;

  @JsonKey(name: 'M_Product_ID')
  ReferenceEntity product;

  @JsonKey(ignore: true)
  OrderMovementLine? orderLine;

  @JsonKey(name: 'BHP_RMovementLine_ID')
  ReferenceEntity omLine;

  @JsonKey(name: 'C_UOM_ID')
  ReferenceEntity uom;

  double qtyEntered;
  double movementQty;

  @JsonKey(ignore: true)
  ReferenceEntity? attributeSet;

  @JsonKey(ignore: true)
  bool isLot;

  @JsonKey(ignore: true)
  bool isLotMandatory;

  @JsonKey(ignore: true)
  bool isSerNo;

  @JsonKey(ignore: true)
  bool isSerNoMandatory;

  @JsonKey(ignore: true)
  bool isGuaranteeDate;

  @JsonKey(ignore: true)
  bool isGuaranteeDateMandatory;

  @JsonKey(ignore: true)
  ReferenceEntity? productCategory;

  @JsonKey(name: 'M_Locator_ID')
  ReferenceEntity? locator;

  @JsonKey(name: 'M_LocatorTo_ID')
  ReferenceEntity? locatorTo;

  @JsonKey(name: 'M_AttributeSetInstance_ID')
  ReferenceEntity? attributeSetInstance;

  @JsonKey(ignore: true)
  AttributeSetInstance? asi;

  @JsonKey(ignore: true)
  String? attributeNo;

  ImtLineEntity(
      {int? id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      this.line = 0,
      this.selected = false,
      required this.product,
      required this.uom,
      this.qtyEntered = 0,
      this.movementQty = 0,
      this.isSerNo = false,
      this.isLot = false,
      this.isGuaranteeDate = false,
      this.isGuaranteeDateMandatory = false,
      this.isLotMandatory = false,
      this.isSerNoMandatory = false,
      this.productCategory,
      this.orderLine,
      required this.omLine,
      this.attributeSet,
      this.attributeSetInstance,
      this.locator,
      this.locatorTo})
      : super(id: id!, client: client, organization: organization);

  factory ImtLineEntity.fromJson(Map<String, dynamic> json) =>
      _$ImtLineEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ImtLineEntityToJson(this);

  set quantity(double value) {
    qtyEntered = value;
    movementQty = qtyEntered;
  }

  double get quantity {
    if (attributeSet != null && isSerNo && !isFullyDelivered) {
      return movementQty;
    }

    movementQty =
        qtyEntered ?? orderLine!.qtyDelivered! - orderLine!.qtyReceipt!;
    return movementQty < 0 ? 0.0 : movementQty;
  }

  bool get isFullyDelivered {
    return orderLine!.qtyReceipt! >= orderLine!.qtyDelivered!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is ImtLineEntity &&
          localUuid == other.localUuid;

  @override
  int get hashCode => runtimeType.hashCode ^ localUuid.hashCode;
}
