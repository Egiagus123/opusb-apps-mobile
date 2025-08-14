import 'package:apps_mobile/business_logic/models/assettrfmodel/tooltrf_line.dart';
// import 'package:eam_mobile/business_logic/models/assettrfmodel/tooltrf_line.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tooltrf_header.g.dart';

@JsonSerializable()
class ToolsTrfHeader extends Equatable {
  @JsonKey(nullable: true, includeIfNull: false)
  String documentNo;
  final String description;

  final List<ToolsTrfLine> detail;

  ToolsTrfHeader(
      {required this.description,
      required this.detail,
      required this.documentNo});
  factory ToolsTrfHeader.fromJson(Map<String, dynamic> json) =>
      _$ToolsTrfHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$ToolsTrfHeaderToJson(this);

  @override
  List<Object> get props => [description];

  @override
  String toString() {
    return 'ToolsTrfHeader[description: $description,detail:$detail ]';
  }
}
