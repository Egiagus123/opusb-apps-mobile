// import 'package:eam_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../reference.dart';
part 'generatetoolstrfline.g.dart';

@JsonSerializable()
class GenerateDataLine extends Equatable {
  @JsonKey(name: 'AD_Org_ID')
  final Reference orgID;

  final String serNo;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference installBase;

  @JsonKey(name: 'BHP_ToolRequestLine_ID')
  final Reference toolRequestLineID;

  num qtyEntered;

  GenerateDataLine({
    required this.orgID,
    required this.serNo,
    required this.installBase,
    required this.qtyEntered,
    required this.toolRequestLineID,
  });
  factory GenerateDataLine.fromJson(Map<String, dynamic> json) =>
      _$GenerateDataLineFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateDataLineToJson(this);

  @override
  List<Object> get props => [serNo];

  @override
  String toString() {
    return 'GenerateDataLine[serNo: $serNo ]';
  }
}
