import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/warehouse_entity.dart';
part 'warehouse_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WarehouseModel extends Warehouse {
  WarehouseModel({
    required ReferenceEntity inTransit,
  }) : super(inTransit: inTransit);

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);
}
