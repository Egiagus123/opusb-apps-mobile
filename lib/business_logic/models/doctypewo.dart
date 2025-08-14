import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'doctypewo.g.dart';

@JsonSerializable()
class DoctypeWOModel extends Equatable {
  final int id;
  final String name;

  DoctypeWOModel({required this.id, required this.name});

  factory DoctypeWOModel.fromJson(Map<String, dynamic> json) =>
      _$DoctypeWOModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctypeWOModelToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'DoctypeWOModel[id: $id]';
  }
}
