import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'image_equipment.g.dart';

@JsonSerializable()
class ImageEquipment extends Equatable {
  final int id;

  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'AD_Org_ID')
  final Reference org;

  final String binaryData, name;

  ImageEquipment({
    required this.id,
    required this.client,
    required this.org,
    required this.binaryData,
    required this.name,
  });

  factory ImageEquipment.fromJson(Map<String, dynamic> json) =>
      _$ImageEquipmentFromJson(json);
  Map<String, dynamic> toJson() => _$ImageEquipmentToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'ImageEquipment[id: $id]';
  }
}
