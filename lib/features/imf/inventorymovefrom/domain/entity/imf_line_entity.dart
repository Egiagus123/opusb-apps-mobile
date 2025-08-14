import 'package:json_annotation/json_annotation.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/util/common_generator.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement_line.dart';

part 'imf_line_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class ImfLineEntity extends BaseEntity {
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
  ReferenceEntity? omLine;

  @JsonKey(name: 'C_UOM_ID')
  final ReferenceEntity uom;

  double? qtyEntered;
  double? movementQty;

  @JsonKey(ignore: true)
  ReferenceEntity? attributeSet;

  @JsonKey(ignore: true)
  bool? isLot;
  @JsonKey(ignore: true)
  bool? isLotMandatory;
  @JsonKey(ignore: true)
  bool? isSerNo;
  @JsonKey(ignore: true)
  bool? isSerNoMandatory;
  @JsonKey(ignore: true)
  bool? isGuaranteeDate;
  @JsonKey(ignore: true)
  bool? isGuaranteeDateMandatory;
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

  ImfLineEntity({
    int? id,
    required ReferenceEntity client,
    required ReferenceEntity organization,
    this.line = 0,
    this.selected = false,
    required this.product,
    required this.uom,
    this.qtyEntered,
    this.movementQty,
    this.isSerNo,
    this.isLot,
    this.isGuaranteeDate,
    this.isGuaranteeDateMandatory,
    this.isLotMandatory,
    this.isSerNoMandatory,
    this.productCategory,
    this.orderLine,
    this.omLine,
    this.attributeSet,
    this.attributeSetInstance,
    this.locator,
    this.locatorTo,
  }) : super(id: id!, client: client, organization: organization);

  factory ImfLineEntity.fromJson(Map<String, dynamic> json) =>
      _$ImfLineEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ImfLineEntityToJson(this);

  set quantity(double value) {
    qtyEntered = value;
    movementQty = value;
  }

  double get quantity {
    if (attributeSet != null && (isSerNo ?? false) && !isFullyDelivered) {
      return movementQty ?? 0.0;
    }

    if (qtyEntered != null) {
      return qtyEntered!;
    }

    if (orderLine != null) {
      final deliveredQty = orderLine!.qtyDelivered;
      final movementQtyOrder = orderLine!.movementQty;
      return (movementQtyOrder - deliveredQty).clamp(0.0, double.infinity);
    }

    return 0.0;
  }

  bool get isFullyDelivered {
    if (orderLine == null) return false;
    return orderLine!.qtyDelivered >= orderLine!.movementQty;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImfLineEntity && localUuid == other.localUuid;

  @override
  int get hashCode => runtimeType.hashCode ^ localUuid.hashCode;
}
