import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assettrackingloc_model.g.dart';

@JsonSerializable()
class AssetTrackingLocation extends Equatable {
  final int id;
  final String value;

  AssetTrackingLocation({
    required this.id,
    required this.value,
  });

  factory AssetTrackingLocation.fromJson(Map<String, dynamic> json) =>
      _$AssetTrackingLocationFromJson(json);
  Map<String, dynamic> toJson() => _$AssetTrackingLocationToJson(this);

  @override
  List<Object> get props => [id, value];

  @override
  String toString() {
    return 'AssetTrackingLocation[id: $id, value: $value]';
  }
}
