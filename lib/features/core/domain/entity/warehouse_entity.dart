import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class WarehouseEntity extends BaseEntity {
  final String name;

  @JsonKey(name: 'M_InTransitLocator_ID')
  final ReferenceEntity inTransitLocator;

  WarehouseEntity({
    int? id,
    required client,
    required organization,
    required this.name,
    required this.inTransitLocator,
  }) : super(id: id!, client: client, organization: organization);
}
