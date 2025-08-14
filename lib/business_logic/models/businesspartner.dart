import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'businesspartner.g.dart';

@JsonSerializable()
class BusinessPartnerModel extends Equatable {
  final int id;
  final String name;

  BusinessPartnerModel({
    required this.id,
    required this.name,
  });

  factory BusinessPartnerModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessPartnerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessPartnerModelToJson(this);

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'BusinessPartnerModel[id: $id]';
  }
}
