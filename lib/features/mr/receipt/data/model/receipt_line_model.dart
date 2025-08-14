import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/mr/po/data/model/order_line_model.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';

part 'receipt_line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceiptLineModel extends ReceiptLineEntity {
  ReceiptLineModel(
      {int? id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      bool selected = false,
      ReferenceEntity? product,
      OrderLine? orderLine,
      int line = 0,
      required ReferenceEntity poLine,
      required ReferenceEntity warehouse,
      required ReferenceEntity locator,
      required ReferenceEntity uom,
      ReferenceEntity? orgTrxId,
      ReferenceEntity? user1,
      ReferenceEntity? user2,
      ReferenceEntity? project,
      ReferenceEntity? projectPhase,
      ReferenceEntity? projectTask,
      ReferenceEntity? activity,
      ReferenceEntity? campaign,
      double? movementQty,
      double? qtyEntered,
      required ReferenceEntity attributeSet,
      ReferenceEntity? attributeSetInstance,
      required bool? isLot,
      required bool? isLotMandatory,
      required bool? isSerNo,
      required bool? isSerNoMandatory,
      required bool? isGuaranteeDate,
      required bool? isGuaranteeDateMandatory})
      : super(
            client: client,
            organization: organization,
            line: line,
            product: product!,
            poLine: poLine,
            orderLine: orderLine!,
            warehouse: warehouse,
            locator: locator,
            uom: uom,
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
            attributeSet: attributeSet,
            attributeSetInstance: attributeSetInstance!,
            isLot: isLot!,
            isLotMandatory: isLotMandatory!,
            isSerNo: isSerNo!,
            isSerNoMandatory: isSerNoMandatory!,
            isGuaranteeDate: isGuaranteeDate!,
            isGuaranteeDateMandatory: isGuaranteeDateMandatory!);

  ReceiptLineModel copy() {
    final model = ReceiptLineModel.fromJson(toJson());

    model.orderLine =
        OrderLineModel.fromJson((orderLine as OrderLineModel).toJson());

    model.product = ReferenceModel.fromJson(product!.toJson());
    return model;
  }

  factory ReceiptLineModel.fromPoLine(
      {PurchaseOrder? po, OrderLine? poLine, int? locatorId}) {
    return ReceiptLineModel(
        client: poLine!.client,
        organization: poLine.organization,
        product: poLine.product,
        line: poLine.line,
        orderLine: poLine, // transient
        poLine: ReferenceModel(id: poLine.id),
        warehouse: po!.warehouse,
        locator: ReferenceModel(id: locatorId),
        uom: poLine.uom,
        orgTrxId: ReferenceModel(id: po.orgTrx?.id),
        user1: ReferenceModel(id: po.user1?.id),
        project: ReferenceModel(id: po.project?.id),
        attributeSet: poLine.attributeSet,
        isGuaranteeDate: poLine.isGuaranteeDate,
        isGuaranteeDateMandatory: poLine.isGuaranteeDateMandatory,
        isLot: poLine.isLot,
        isLotMandatory: poLine.isLotMandatory,
        isSerNo: poLine.isSerNo,
        isSerNoMandatory: poLine.isSerNoMandatory)
      ..selected = true
      ..quantity = poLine.reservedQuantity;
  }

  factory ReceiptLineModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptLineModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptLineModelToJson(this);
}
