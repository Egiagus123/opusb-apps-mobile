import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'installbasetrf.g.dart';

@JsonSerializable()
class InstallBaseTransfer extends Equatable {
  final int id;

  @JsonKey(name: 'BHP_ToolTransfer_ID')
  final Reference tooltrfID;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference installBaseID;

  final int duration;
  final String dateDoc;

  @JsonKey(name: 'M_Locator_ID')
  final Reference from;

  @JsonKey(name: 'M_Locator_New_ID')
  final Reference to;

  @JsonKey(name: 'C_BPartnerSR_New_ID')
  final Reference bpartnerSR;

  @JsonKey(name: 'C_DocType_ID')
  final Reference doctype;

  InstallBaseTransfer(
      {required this.id,
      required this.tooltrfID,
      required this.installBaseID,
      required this.dateDoc,
      required this.bpartnerSR,
      required this.duration,
      required this.doctype,
      required this.from,
      required this.to});

  factory InstallBaseTransfer.fromJson(Map<String, dynamic> json) =>
      _$InstallBaseTransferFromJson(json);
  Map<String, dynamic> toJson() => _$InstallBaseTransferToJson(this);

  @override
  List<Object> get props => [
        id,
        from,
        to,
        installBaseID,
        duration,
        bpartnerSR,
        doctype,
        dateDoc,
        tooltrfID
      ];

  @override
  String toString() {
    return 'InstallBaseTransfer[id: $id]';
  }
}
