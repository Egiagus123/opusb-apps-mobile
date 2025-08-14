import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/locator_entity.dart';

part 'locator_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LocatorModel extends LocatorEntity {
  LocatorModel(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required String x,
      required String y,
      required String z,
      required String value,
      required int priorityNo,
      required bool defaultLocator})
      : super(
            id: id,
            client: client,
            organization: organization,
            x: x,
            y: y,
            z: z,
            value: value,
            priorityNo: priorityNo,
            defaultLocator: defaultLocator);

  factory LocatorModel.fromJson(Map<String, dynamic> json) =>
      _$LocatorModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocatorModelToJson(this);
}
