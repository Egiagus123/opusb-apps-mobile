import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assettrf_model.g.dart';

@JsonSerializable()
class AssetTrfData extends Equatable {
  final String? warehouse;

  final String? trfby;
  final String? prodname;
  final String? qty;
  final String? uom;

  AssetTrfData({this.warehouse, this.trfby, this.prodname, this.qty, this.uom});
  @override
  List<Object> get props => [warehouse!, trfby!, prodname!, qty!, uom!];

  factory AssetTrfData.fromJson(Map<String, dynamic> json) =>
      _$AssetTrfDataFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTrfDataToJson(this);
}
