import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'employeegroup.g.dart';

@JsonSerializable()
class EmployeeGroupModel extends Equatable {
  final int id;
  final String name;

  EmployeeGroupModel({required this.id, required this.name});

  factory EmployeeGroupModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeGroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeGroupModelToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'DoctypeWOModel[id: $id]';
  }
}
