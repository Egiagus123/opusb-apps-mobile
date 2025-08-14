import 'package:json_annotation/json_annotation.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

part 'reference_model.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class ReferenceModel extends ReferenceEntity {
  ReferenceModel({dynamic id, String? propertyLabel, String? identifier})
      : super(id: id, propertyLabel: propertyLabel, identifier: identifier);

  factory ReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$ReferenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceModelToJson(this);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  factory ReferenceModel.defaultReference() {
    return ReferenceModel(
      id: 'default',
      propertyLabel: '',
      identifier: '',
    ); // Replace 'default' with your actual default value
  }
}
