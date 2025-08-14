// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'container_model.g.dart';

@JsonSerializable()
class ContainerShipment extends Equatable {
  int id;
  String value;

  ContainerShipment({
    required this.id,
    required this.value,
  });

  factory ContainerShipment.fromJson(Map<String, dynamic> json) =>
      _$ContainerShipmentFromJson(json);
  Map<String, dynamic> toJson() => _$ContainerShipmentToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'ContainerShipment[id: $id, value: $value]';
  }
}
