import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class BaseEntity {
  @JsonKey(nullable: true, includeIfNull: false)
  final int id;

  @JsonKey(name: 'AD_Client_ID', nullable: true, includeIfNull: false)
  final ReferenceEntity client;

  @JsonKey(name: 'AD_Org_ID', nullable: true, includeIfNull: false)
  final ReferenceEntity organization;

  BaseEntity(
      {required this.id,
      required this.client,
      required this.organization,
      List props = const []});
}
