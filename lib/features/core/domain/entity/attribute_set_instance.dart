import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class AttributeSetInstance extends BaseEntity {
  @JsonKey(name: 'M_AttributeSet_ID')
  ReferenceEntity attributeSet;

  String description;

  @JsonKey(nullable: true, includeIfNull: false)
  String lot;

  @JsonKey(name: 'serNo', nullable: true, includeIfNull: false)
  String serialNo;

  String tableName;

  AttributeSetInstance(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required this.attributeSet,
      required this.description,
      required this.lot,
      required this.serialNo,
      this.tableName = 'M_AttributeSetInstance'})
      : super(id: id, client: client, organization: organization);
}
