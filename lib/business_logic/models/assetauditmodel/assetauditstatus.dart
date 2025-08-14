import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assetauditstatus.g.dart';

@JsonSerializable()
class AssetAuditStatusModel extends Equatable {
  final int id;

  final String name, value;

  AssetAuditStatusModel({
    required this.id,
    required this.name,
    required this.value,
  });

  factory AssetAuditStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AssetAuditStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetAuditStatusModelToJson(this);

  @override
  List<Object> get props => [id, name, value];

  @override
  String toString() {
    return 'AssetAuditStatusModel[id: $id, name: $name,value: $value]';
  }
}
