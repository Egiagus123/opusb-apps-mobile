import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bplocation.g.dart';

@JsonSerializable()
class BPLocationModel extends Equatable {
  final int id;
  final String name;
  final Reference bpartnerid;

  BPLocationModel(
      {required this.id, required this.name, required this.bpartnerid});

  factory BPLocationModel.fromJson(Map<String, dynamic> json) =>
      _$BPLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$BPLocationModelToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'BPLocationModel[id: $id]';
  }
}
