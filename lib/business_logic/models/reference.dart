import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reference.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class Reference extends Equatable {
  final String? propertyLabel;
  final dynamic id;
  final String? identifier;
  final String? modelName;

  final String? value;

  Reference(
      {this.propertyLabel,
      this.id,
      this.identifier,
      this.modelName,
      this.value});

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceToJson(this);

  @override
  List<Object> get props =>
      [propertyLabel!, id, identifier!, modelName!, value!];

  @override
  String toString() {
    return 'Reference[modelName: $modelName, id: $id, identifier: $identifier]';
  }

  factory Reference.defaultReference() {
    return Reference(
        id: 'default',
        propertyLabel: '',
        identifier: '',
        modelName: '',
        value: ''); // Replace 'default' with your actual default value
  }
}
