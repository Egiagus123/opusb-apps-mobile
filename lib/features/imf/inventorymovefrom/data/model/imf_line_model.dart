import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/data/model/order_movement_line_model.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement_line.dart';

part 'imf_line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImfLineModel extends ImfLineEntity {
  double devided;

  ImfLineModel({
    int? id,
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
    required ReferenceEntity omLine,
    ReferenceEntity? attributeSetInstance,
    this.devided = 0.0, // memberi nilai default pada devided
  }) : super(
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
          omLine: omLine,
          attributeSet: attributeSet!,
          attributeSetInstance: attributeSetInstance!,
        );

  ImfLineModel copy() {
    final model = ImfLineModel.fromJson(toJson());

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

  factory ImfLineModel.fromPoLine({
    required OrderMovement om,
    required OrderMovementLine omLine,
  }) {
    debugPrint(
        'Product ${omLine.product.identifier} has attribute set: ${omLine.attributeSet}');

    return ImfLineModel(
      client: ReferenceEntity(id: omLine.client.id),
      organization: ReferenceEntity(id: omLine.organization.id),
      product: omLine.product,
      orderLine: omLine,
      omLine: ReferenceEntity(id: omLine.id),
      uom: omLine.uom,
      attributeSet: omLine.attributeSet,
      isGuaranteeDate: omLine.isGuaranteeDate!,
      isGuaranteeDateMandatory: omLine.isGuaranteeDateMandatory!,
      isLot: omLine.isLot!,
      isLotMandatory: omLine.isLotMandatory!,
      isSerNo: omLine.isSerNo!,
      isSerNoMandatory: omLine.isSerNoMandatory!,
      attributeSetInstance: omLine.attributeSetInstance,
    )
      ..selected = true
      ..quantity = omLine.qtyEntered == omLine.movementQty
          ? omLine.movementQty - omLine.qtyDelivered
          : ((omLine.movementQty - omLine.qtyDelivered) /
              (omLine.movementQty / omLine.qtyEntered));
  }

  factory ImfLineModel.fromJson(Map<String, dynamic> json) =>
      _$ImfLineModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImfLineModelToJson(this);
}
