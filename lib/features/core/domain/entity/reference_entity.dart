import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reference_entity.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class ReferenceEntity extends Equatable {
  final dynamic id;
  final String? propertyLabel;
  final String? identifier;

  ReferenceEntity({this.id, this.identifier, this.propertyLabel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other is ReferenceEntity &&
          id == other.id &&
          identifier == other.identifier;

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode ^ identifier.hashCode;

  @override
  List<Object> get props => [id, propertyLabel!, identifier!];

  factory ReferenceEntity.fromJson(Map<String, dynamic> json) =>
      _$ReferenceEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceEntityToJson(this);

  factory ReferenceEntity.defaultReference() {
    return ReferenceEntity(
      id: 'default',
      propertyLabel: '',
      identifier: '',
    ); // Replace 'default' with your actual default value
  }
}
