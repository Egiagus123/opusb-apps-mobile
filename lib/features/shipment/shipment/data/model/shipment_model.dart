import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

part 'shipment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShipmentModel extends ShipmentEntity {
  ShipmentModel(
      {int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      bool isSoTrx = false,
      @required ReferenceEntity? order,
      ReferenceEntity? docType,
      @required ReferenceEntity? businessPartner,
      @required ReferenceEntity? businessPartnerLocation,
      @required ReferenceEntity? warehouse,
      @required ReferenceEntity? movementType,
      @required ReferenceEntity? deliveryRule,
      @required ReferenceEntity? deliveryViaRule,
      ReferenceEntity? priorityRule,
      @required String? freightAmt,
      @required ReferenceEntity? freightCostRule,
      @required bool? isDropShip,
      @required ReferenceEntity? salesRepresentative,
      @required ReferenceEntity? orgTrx,
      @required ReferenceEntity? user1,
      ReferenceEntity? user2,
      ReferenceEntity? project,
      ReferenceEntity? activity,
      ReferenceEntity? campaign,
      ReferenceEntity? shipper,
      List<ShipmentLineEntity>? lines,
      String docAction = 'CO',
      bool isMobileTrx = true})
      : super(
            id: id!,
            client: client!,
            organization: organization!,
            order: order!,
            docType: docType!,
            businessPartner: businessPartner!,
            businessPartnerLocation: businessPartnerLocation!,
            warehouse: warehouse!,
            movementType: movementType!,
            deliveryRule: deliveryRule!,
            deliveryViaRule: deliveryViaRule!,
            priorityRule: priorityRule!,
            freightAmt: freightAmt!,
            freightCostRule: freightCostRule!,
            isDropShip: isDropShip!,
            salesRepresentative: salesRepresentative!,
            orgTrx: orgTrx!,
            user1: user1!,
            user2: user2!,
            project: project!,
            activity: activity!,
            campaign: campaign!,
            shipper: shipper!,
            lines: lines!,
            docAction: docAction,
            isMobileTrx: isMobileTrx);

  factory ShipmentModel.fromPo(SalesOrder po) {
    return ShipmentModel(
      order: ReferenceModel(id: po.id),
      movementType: ReferenceModel(id: 'C-'),
      businessPartner: ReferenceModel(id: po.businessPartner!.id),
      businessPartnerLocation:
          ReferenceModel(id: po.businessPartnerLocation!.id),
      deliveryRule: ReferenceModel(id: po.deliveryRule?.id),
      deliveryViaRule: ReferenceModel(id: po.deliveryViaRule?.id),
      priorityRule: po.priorityRule,
      freightAmt: po.freightAmt,
      freightCostRule: ReferenceModel(id: po.freightCostRule?.id),
      isDropShip: po.isDropShip,
      warehouse: ReferenceModel(id: po.warehouse!.id),
      orgTrx: ReferenceModel(id: po.orgTrx?.id),
      user1: ReferenceModel(id: po.user1?.id),
      salesRepresentative: ReferenceModel(id: po.salesRepresentative?.id),
      project: ReferenceModel(id: po.project?.id),
    );
  }

  factory ShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentModelToJson(this);
}
