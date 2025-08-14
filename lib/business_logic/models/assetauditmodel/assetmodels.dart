import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../reference.dart';
part 'assetmodels.g.dart';

@JsonSerializable()
class AssetModel extends Equatable {
  final int id;

  final String name, value;
  @JsonKey(name: 'A_Asset_Status')
  Reference assetstatus;

  AssetModel({
    required this.id,
    required this.name,
    required this.value,
    required this.assetstatus,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetModelToJson(this);

  @override
  List<Object> get props => [id, name, value, assetstatus];

  @override
  String toString() {
    return 'AssetModel[id: $id, name: $name,value: $value,assetstatus:$assetstatus]';
  }
}
