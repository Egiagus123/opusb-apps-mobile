import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'priority.g.dart';

@JsonSerializable()
class PriorityModel extends Equatable {
  final int id;
  final String name, value;

  PriorityModel({required this.id, required this.name, required this.value});

  factory PriorityModel.fromJson(Map<String, dynamic> json) =>
      _$PriorityModelFromJson(json);
  Map<String, dynamic> toJson() => _$PriorityModelToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'PriorityModel[id: $id]';
  }
}
