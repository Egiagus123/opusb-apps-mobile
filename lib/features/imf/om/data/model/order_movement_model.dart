import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

part 'order_movement_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderMovementModel extends OrderMovement {
  OrderMovementModel({
    required int id,
    required ReferenceEntity client,
    required ReferenceEntity organization,
    required String documentNo,
    String? description,
    String? poReference,
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
    ReferenceEntity? project,
    required ReferenceEntity docStatus,
    required ReferenceEntity docType,
  }) : super(
          id: id,
          client: client,
          organization: organization,
          documentNo: documentNo,
          description: description!,
          poReference: poReference!,
          movementDate: movementDate,
          shipper: shipper!,
          priorityRule: priorityRule!,
          deliveryViaRule: deliveryViaRule!,
          deliveryRule: deliveryRule!,
          warehouse: warehouse,
          warehouseTo: warehouseTo,
          orgTrx: orgTrx!,
          user1: user1!,
          salesRepresentative: salesRepresentative!,
          project: project!,
          docStatus: docStatus,
          docType: docType,
        );

  factory OrderMovementModel.fromJson(Map<String, dynamic> json) =>
      _$OrderMovementModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderMovementModelToJson(this);
}
