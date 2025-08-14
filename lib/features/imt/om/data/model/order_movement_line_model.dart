import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';

part 'order_movement_line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderMovementLineModel extends OrderMovementLine {
  OrderMovementLineModel(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required int line,
      required ReferenceEntity product,
      required ReferenceEntity uom,
      required double movementQty,
      required double qtyDelivered,
      required double qtyReceipt,
      required double qtyEntered,
      bool? processed,
      required ReferenceEntity attributeSet,
      required ReferenceEntity attributeSetInstance,
      bool isSerNo = false,
      bool isLot = false,
      bool isGuaranteeDate = false,
      bool isGuaranteeDateMandatory = false,
      bool isLotMandatory = false,
      bool isSerNoMandatory = false})
      : super(
          id: id,
          client: client,
          organization: organization,
          line: line,
          product: product,
          qtyEntered: qtyEntered,
          uom: uom,
          movementQty: movementQty,
          qtyDelivered: qtyDelivered,
          qtyReceipt: qtyReceipt,
          isSerNo: isSerNo,
          isLot: isLot,
          isGuaranteeDate: isGuaranteeDate,
          isGuaranteeDateMandatory: isGuaranteeDateMandatory,
          isLotMandatory: isLotMandatory,
          isSerNoMandatory: isSerNoMandatory,
          attributeSet: attributeSet,
          attributeSetInstance: attributeSetInstance,
        );

  factory OrderMovementLineModel.fromJson(Map<String, dynamic> json) =>
      _$OrderMovementLineModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderMovementLineModelToJson(this);
}
