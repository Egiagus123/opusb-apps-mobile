import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';

part 'receipt_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceiptModel extends ReceiptEntity {
  ReceiptModel(
      {int? id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      bool isSoTrx = false,
      required ReferenceEntity order,
      ReferenceEntity? docType,
      required ReferenceEntity businessPartner,
      required ReferenceEntity businessPartnerLocation,
      required ReferenceEntity warehouse,
      required ReferenceEntity movementType,
      required ReferenceEntity deliveryRule,
      required ReferenceEntity deliveryViaRule,
      required String freightAmt,
      required ReferenceEntity freightCostRule,
      required bool isDropShip,
      required ReferenceEntity salesRepresentative,
      required ReferenceEntity orgTrx,
      required ReferenceEntity user1,
      ReferenceEntity? user2,
      ReferenceEntity? project,
      ReferenceEntity? activity,
      ReferenceEntity? campaign,
      ReferenceEntity? shipper,
      List<ReceiptLineEntity>? lines,
      String docAction = 'CO',
      bool isMobileTrx = true})
      : super(
            id: id!,
            client: client,
            organization: organization,
            order: order,
            docType: docType!,
            businessPartner: businessPartner,
            businessPartnerLocation: businessPartnerLocation,
            warehouse: warehouse,
            movementType: movementType,
            deliveryRule: deliveryRule,
            deliveryViaRule: deliveryViaRule,
            freightAmt: freightAmt,
            freightCostRule: freightCostRule,
            isDropShip: isDropShip,
            salesRepresentative: salesRepresentative,
            orgTrx: orgTrx,
            user1: user1,
            user2: user2!,
            project: project!,
            activity: activity!,
            campaign: campaign!,
            shipper: shipper!,
            lines: lines!,
            isMobileTrx: isMobileTrx,
            docAction: docAction);

  factory ReceiptModel.fromPo(PurchaseOrder po) {
    return ReceiptModel(
      client: ReferenceModel(id: po.client.id),
      organization: ReferenceModel(id: po.organization.id),
      order: ReferenceModel(id: po.id),
      movementType: ReferenceModel(id: 'V+'),
      businessPartner: ReferenceModel(id: po.businessPartner.id),
      businessPartnerLocation:
          ReferenceModel(id: po.businessPartnerLocation.id),
      deliveryRule: ReferenceModel(id: po.deliveryRule?.id),
      deliveryViaRule: ReferenceModel(id: po.deliveryViaRule?.id),
      freightAmt: po.freightAmt,
      freightCostRule: ReferenceModel(id: po.freightCostRule?.id),
      isDropShip: po.isDropShip,
      warehouse: ReferenceModel(id: po.warehouse.id),
      orgTrx: ReferenceModel(id: po.orgTrx?.id),
      user1: ReferenceModel(id: po.user1?.id),
      salesRepresentative: ReferenceModel(id: po.salesRepresentative?.id),
      project: ReferenceModel(id: po.project?.id),
    );
  }

  factory ReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptModelToJson(this);
}
