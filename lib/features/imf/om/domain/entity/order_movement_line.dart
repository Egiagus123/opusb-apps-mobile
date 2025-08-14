import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class OrderMovementLine extends BaseEntity {
  final int line;

  @JsonKey(name: 'M_Product_ID')
  final ReferenceEntity product;

  @JsonKey(name: 'C_UOM_ID')
  final ReferenceEntity uom;

  double movementQty;
  double qtyReceipt;
  double qtyDelivered;
  @JsonKey(nullable: false)
  double qtyEntered;

  @JsonKey(name: 'M_AttributeSet_ID')
  ReferenceEntity? attributeSet;

  @JsonKey(name: 'M_AttributeSetInstance_ID')
  ReferenceEntity? attributeSetInstance;

  final bool? isLot;
  final bool? isLotMandatory;
  final bool? isSerNo;
  final bool? isSerNoMandatory;
  final bool? isGuaranteeDate;
  final bool? isGuaranteeDateMandatory;

  @JsonKey(name: 'M_Product_Category_ID')
  ReferenceEntity? productCategory;

  OrderMovementLine(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required this.line,
      required this.product,
      required this.uom,
      required this.qtyReceipt,
      required this.movementQty,
      required this.qtyDelivered,
      required this.qtyEntered,
      this.isSerNo,
      this.isLot,
      this.isGuaranteeDate,
      this.isGuaranteeDateMandatory,
      this.isLotMandatory,
      this.isSerNoMandatory,
      this.productCategory,
      this.attributeSet,
      this.attributeSetInstance})
      : super(
          id: id,
          client: client,
          organization: organization,
        );

  /// Get the actual reserved quantity.
  double get reservedQuantity {
    return movementQty - qtyDelivered;
  }
}
