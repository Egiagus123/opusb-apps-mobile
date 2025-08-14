import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assetrequestline_model.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class AssetRequestLine extends Equatable {
  int id;

  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'AD_Org_ID')
  final Reference org;

  @JsonKey(name: 'BHP_ToolRequest_ID')
  final Reference toolReqID;

  final num qtyEntered, qtyDelivered, qtyReceipt;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference installbase;

  String serNo;

  @JsonKey(ignore: true)
  bool isSerNo;
  @JsonKey(ignore: true)
  bool selected;

  AssetRequestLine(
      {required this.id,
      required this.client,
      required this.installbase,
      required this.toolReqID,
      required this.qtyDelivered,
      required this.qtyEntered,
      required this.qtyReceipt,
      required this.org,
      required this.serNo,
      required this.isSerNo,
      required this.selected});

  factory AssetRequestLine.fromJson(Map<String, dynamic> json) =>
      _$AssetRequestLineFromJson(json);
  Map<String, dynamic> toJson() => _$AssetRequestLineToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'AssetRequestLine[id: $id]';
  }
}
