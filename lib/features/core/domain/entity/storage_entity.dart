import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class StorageEntity extends BaseEntity {
  @JsonKey(name: 'M_AttributeSetInstance_ID')
  final ReferenceEntity asi;

  StorageEntity(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required this.asi})
      : super(id: id, client: client, organization: organization);
}
