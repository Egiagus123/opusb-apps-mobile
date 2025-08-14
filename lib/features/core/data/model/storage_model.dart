import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';

part 'storage_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StorageModel extends StorageEntity {
  StorageModel(
      {required int id,
      required ReferenceModel client,
      required ReferenceModel organization,
      required ReferenceModel asi})
      : super(id: id, client: client, organization: organization, asi: asi);

  factory StorageModel.fromJson(Map<String, dynamic> json) =>
      _$StorageModelFromJson(json);
  Map<String, dynamic> toJson() => _$StorageModelToJson(this);
}
