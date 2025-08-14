import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/warehouse_entity.dart';

part 'warehouse_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WarehouseModel extends WarehouseEntity {
  WarehouseModel(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required String name,
      required ReferenceEntity inTransitLocator})
      : super(
            id: id,
            client: client,
            organization: organization,
            name: name,
            inTransitLocator: inTransitLocator);

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);
}
