import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'shipment_model.g.dart';

@JsonSerializable()
class ShipmentTemporarry extends Equatable {
  int? id;

  @JsonKey(name: 'TRM_M_CONT_ID')
  final Reference? container;
  String? containerNo, weight1, quantity, Tare_Weight;
  double? qtyEntered;

  ShipmentTemporarry({
    this.id,
    this.container,
    this.containerNo,
    this.Tare_Weight,
    this.qtyEntered,
    this.quantity,
    this.weight1,
  });

  factory ShipmentTemporarry.fromJson(Map<String, dynamic> json) =>
      _$ShipmentTemporarryFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentTemporarryToJson(this);

  @override
  List<Object> get props => [id!];

  @override
  String toString() {
    return 'ShipmentTemporarry[id: $id]';
  }
}
