import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

part 'attribute_set_instance_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AttributeSetInstanceModel extends AttributeSetInstance {
  AttributeSetInstanceModel(
      {int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      ReferenceEntity? attributeSet,
      String? description,
      String? lot,
      String? serialNo})
      : super(
            id: id!,
            client: client!,
            organization: organization!,
            attributeSet: attributeSet!,
            description: description!,
            lot: lot!,
            serialNo: serialNo!);

  factory AttributeSetInstanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttributeSetInstanceModelFromJson(json);
  Map<String, dynamic> toJson() => _$AttributeSetInstanceModelToJson(this);
}
