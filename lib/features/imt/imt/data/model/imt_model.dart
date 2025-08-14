import 'dart:io';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';

part 'imt_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ImtModel extends ImtEntity {
  ImtModel({
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
    List<ImtLineEntity>? lines,
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

  factory ImtModel.fromPo(OrderMovement po) {
    final formatter = DateFormat.yMd();
    final date = DateTime.now();

    return ImtModel(
        client: ReferenceModel(id: po.client.id),
        organization: ReferenceModel(id: po.organization.id),
        docType: ReferenceModel(id: po.docType.id),
        movementDate: formatter.format(date),
        warehouse: ReferenceModel(id: po.warehouse.id),
        warehouseTo: ReferenceModel(id: po.warehouseTo.id),
        shipper: ReferenceEntity(id: po.shipper?.id),
        deliveryRule: po.deliveryRule,
        deliveryViaRule: po.deliveryViaRule,
        priorityRule: ReferenceModel(id: po.priorityRule?.id),
        orgTrx: ReferenceModel(id: po.orgTrx?.id),
        user1: ReferenceModel(id: po.user1?.id),
        salesRepresentative: po.salesRepresentative,
        orderMovement: ReferenceModel(id: po.id),
        description: po.description ?? '',
        poReference: po.poReference ?? '');
  }

  factory ImtModel.fromJson(Map<String, dynamic> json) =>
      _$ImtModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImtModelToJson(this);
}
