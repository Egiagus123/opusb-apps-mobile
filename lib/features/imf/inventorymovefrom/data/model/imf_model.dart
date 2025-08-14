import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

part 'imf_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImfModel extends ImfEntity {
  ImfModel({
    int? id,
    required ReferenceEntity client,
    required ReferenceEntity organization,
    String description = '',
    String poReference = '',
    required String movementDate,
    ReferenceEntity? shipper,
    ReferenceEntity? priorityRule,
    ReferenceEntity? deliveryViaRule,
    ReferenceEntity? deliveryRule,
    required ReferenceEntity warehouse,
    required ReferenceEntity warehouseTo,
    ReferenceEntity? orgTrx,
    ReferenceEntity? user1,
    ReferenceEntity? salesRepresentative,
    required ReferenceEntity docType,
    List<ImfLineEntity>? lines,
    String docAction = 'CO',
    bool isMobileTrx = true,
    required ReferenceEntity orderMovement,
  }) : super(
            id: id!,
            client: client,
            organization: organization,
            docType: docType,
            warehouse: warehouse,
            priorityRule: priorityRule!,
            deliveryRule: deliveryRule!,
            deliveryViaRule: deliveryViaRule!,
            orgTrx: orgTrx!,
            shipper: shipper!,
            docAction: docAction,
            description: description,
            poReference: poReference,
            movementDate: movementDate,
            warehouseTo: warehouseTo,
            user1: user1!,
            salesRepresentative: salesRepresentative!,
            orderMovement: orderMovement,
            isMobileTrx: isMobileTrx,
            lines: lines!);

  factory ImfModel.fromOm(OrderMovement om) {
    final formatter = DateFormat.yMd();
    final date = DateTime.now();

    return ImfModel(
        client: ReferenceModel(id: om.client.id),
        organization: ReferenceModel(id: om.organization.id),
        docType: ReferenceModel(id: om.docType.id),
        movementDate: formatter.format(date),

        // IMF's Warehouse is set to OM's Warehouse-requester.
        warehouse: ReferenceModel(id: om.warehouseTo.id),

        // IMF's Warehouse-to is set to OM's Warehouse-inTransit.
        warehouseTo: ReferenceModel(id: om.warehouse.id),
        shipper: ReferenceEntity(id: om.shipper?.id),
        deliveryRule: ReferenceModel(id: om.deliveryRule?.id),
        deliveryViaRule: ReferenceModel(id: om.deliveryViaRule?.id),
        priorityRule: ReferenceModel(id: om.priorityRule?.id),
        orgTrx: ReferenceModel(id: om.orgTrx?.id),
        user1: ReferenceModel(id: om.user1?.id),
        salesRepresentative: ReferenceModel(id: om.salesRepresentative?.id),
        orderMovement: ReferenceModel(id: om.id),
        description: om.description ?? '',
        poReference: om.poReference ?? '');
  }

  factory ImfModel.fromJson(Map<String, dynamic> json) =>
      _$ImfModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImfModelToJson(this);
}
