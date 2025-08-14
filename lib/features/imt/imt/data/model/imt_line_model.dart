import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/om/data/model/order_movement_line_model.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';

part 'imt_line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImtLineModel extends ImtLineEntity {
  ImtLineModel(
      {int? id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      bool selected = false,
      required ReferenceEntity product,
      required ReferenceEntity uom,
      double? qtyEntered,
      double? movementQty,
      ReferenceEntity? locator,
      ReferenceEntity? locatorTo,
      ReferenceEntity? attributeSet,
      bool isSerNo = false,
      bool isLot = false,
      bool isGuaranteeDate = false,
      bool isGuaranteeDateMandatory = false,
      bool isLotMandatory = false,
      bool isSerNoMandatory = false,
      OrderMovementLine? orderLine,
      @required ReferenceEntity? omLine,
      ReferenceEntity? attributeSetInstance})
      : super(
          id: id!,
          client: client,
          organization: organization,
          product: product,
          uom: uom,
          qtyEntered: qtyEntered!,
          movementQty: movementQty!,
          locator: locator!,
          locatorTo: locatorTo!,
          isSerNo: isSerNo,
          isLot: isLot,
          isGuaranteeDate: isGuaranteeDate,
          isGuaranteeDateMandatory: isGuaranteeDateMandatory,
          isLotMandatory: isLotMandatory,
          isSerNoMandatory: isSerNoMandatory,
          orderLine: orderLine!,
          omLine: omLine!,
          attributeSet: attributeSet!,
          attributeSetInstance: attributeSetInstance!,
        );

  ImtLineModel copy() {
    final model = ImtLineModel.fromJson(toJson());
    model
      ..orderLine = OrderMovementLineModel.fromJson(
          (orderLine as OrderMovementLineModel).toJson())
      ..product = product
      ..attributeSet = attributeSet
      ..isLot = isLot
      ..isLotMandatory = isLotMandatory
      ..isSerNo = isSerNo
      ..isSerNoMandatory = isSerNoMandatory
      ..isGuaranteeDate = isGuaranteeDate
      ..isGuaranteeDateMandatory = isGuaranteeDateMandatory;

    return model;
  }

  factory ImtLineModel.fromPoLine(
      {required OrderMovement po,
      OrderMovementLine? poLine,
      int? locatorId,
      int? locatorToId}) {
    return ImtLineModel(
        client: ReferenceEntity(id: poLine?.client.id),
        organization: ReferenceEntity(id: poLine?.organization.id),
        product: poLine!.product,
        uom: poLine.uom,
        attributeSet: poLine.attributeSet,
        isGuaranteeDate: poLine.isGuaranteeDate!,
        isGuaranteeDateMandatory: poLine.isGuaranteeDateMandatory!,
        isLot: poLine.isLot!,
        isLotMandatory: poLine.isLotMandatory!,
        isSerNo: poLine.isSerNo!,
        isSerNoMandatory: poLine.isSerNoMandatory!,
        orderLine: poLine,
        omLine: ReferenceEntity(id: poLine.id),
        attributeSetInstance: poLine.attributeSetInstance)
      ..selected = true
      ..quantity = poLine.qtyEntered == poLine.movementQty
          ? poLine.qtyDelivered! - poLine.qtyReceipt!
          : ((poLine.qtyDelivered! - poLine.qtyReceipt!) /
              (poLine.movementQty / poLine.qtyEntered!));
  }

  factory ImtLineModel.fromJson(Map<String, dynamic> json) =>
      _$ImtLineModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImtLineModelToJson(this);
}
