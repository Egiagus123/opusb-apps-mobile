import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'wostatus.g.dart';

@JsonSerializable()
class WOStatusModel extends Equatable {
  final int id;
  final String name, value;

  WOStatusModel({required this.id, required this.name, required this.value});

  factory WOStatusModel.fromJson(Map<String, dynamic> json) =>
      _$WOStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$WOStatusModelToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'WOStatusModel[id: $id,name: $name, value: $value]';
  }
}
