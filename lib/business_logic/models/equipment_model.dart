import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'equipment_model.g.dart';

@JsonSerializable()
class EquipmentModel extends Equatable {
  final int id;

  final String documentNo, serNo;

  EquipmentModel({
    required this.id,
    required this.documentNo,
    required this.serNo,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$EquipmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentModelToJson(this);

  @override
  List<Object> get props => [id, documentNo];

  @override
  String toString() {
    return 'EquipmentModel[id: $id]';
  }
}
