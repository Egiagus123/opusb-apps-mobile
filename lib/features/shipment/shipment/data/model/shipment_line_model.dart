import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/so/data/model/order_line_model.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/order_line.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

part 'shipment_line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShipmentLineModel extends ShipmentLineEntity {
  ShipmentLineModel(
      {int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      bool selected = false,
      ReferenceEntity? product,
      OrderLine? orderLine,
      @required int? line,
      @required ReferenceEntity? poLine,
      @required ReferenceEntity? warehouse,
      @required ReferenceEntity? locator,
      @required ReferenceEntity? uom,
      @required ReferenceEntity? orgTrxId,
      @required ReferenceEntity? user1,
      ReferenceEntity? user2,
      ReferenceEntity? project,
      ReferenceEntity? projectPhase,
      ReferenceEntity? projectTask,
      ReferenceEntity? activity,
      ReferenceEntity? campaign,
      double? movementQty,
      double? qtyEntered,
      @required ReferenceEntity? attributeSet,
      ReferenceEntity? attributeSetInstance,
      @required bool? isLot,
      @required bool? isLotMandatory,
      @required bool? isSerNo,
      @required bool? isSerNoMandatory,
      @required bool? isGuaranteeDate,
      @required bool? isGuaranteeDateMandatory})
      : super(
            id: id!,
            client: client!,
            organization: organization!,
            line: line!,
            product: product!,
            poLine: poLine!,
            orderLine: orderLine!,
            warehouse: warehouse!,
            locator: locator!,
            uom: uom!,
            orgTrxId: orgTrxId!,
            user1: user1!,
            user2: user2!,
            project: project!,
            projectPhase: projectPhase!,
            projectTask: projectTask!,
            activity: activity!,
            campaign: campaign!,
            movementQty: movementQty!,
            qtyEntered: qtyEntered!,
            attributeSet: attributeSet!,
            attributeSetInstance: attributeSetInstance!,
            isLot: isLot!,
            isLotMandatory: isLotMandatory!,
            isSerNo: isSerNo!,
            isSerNoMandatory: isSerNoMandatory!,
            isGuaranteeDate: isGuaranteeDate!,
            isGuaranteeDateMandatory: isGuaranteeDateMandatory!);

  ShipmentLineModel copy() {
    final model = ShipmentLineModel.fromJson(toJson());

    model.orderLine =
        OrderLineModel.fromJson((orderLine as OrderLineModel).toJson());

    model.product = ReferenceModel.fromJson(product!.toJson());
    return model;
  }

  factory ShipmentLineModel.fromPoLine(
      {SalesOrder? so, OrderLine? soLine, int? locatorId}) {
    return ShipmentLineModel(
        product: soLine!.product,
        line: soLine.line,
        orderLine: soLine, // transient
        poLine: ReferenceModel(id: soLine.id),
        warehouse: so!.warehouse,
        locator: ReferenceModel(id: locatorId),
        uom: soLine.uom,
        orgTrxId: ReferenceModel(id: so.orgTrx?.id),
        user1: ReferenceModel(id: so.user1?.id),
        project: so.project == null ? null : ReferenceModel(id: so.project!.id),
        attributeSet: soLine.attributeSet,
        isGuaranteeDate: soLine.isGuaranteeDate,
        isGuaranteeDateMandatory: soLine.isGuaranteeDateMandatory,
        isLot: soLine.isLot,
        isLotMandatory: soLine.isLotMandatory,
        isSerNo: soLine.isSerNo,
        isSerNoMandatory: soLine.isSerNoMandatory)
      ..selected = true
      ..quantity = soLine.reservedQuantity;
  }

  factory ShipmentLineModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentLineModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentLineModelToJson(this);
}
