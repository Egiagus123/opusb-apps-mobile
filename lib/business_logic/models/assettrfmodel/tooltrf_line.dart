import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../reference.dart';
part 'tooltrf_line.g.dart';

@JsonSerializable()
class ToolsTrfLine extends Equatable {
  @JsonKey(name: 'C_DocType_ID')
  Reference doctype;

  @JsonKey(name: 'M_Locator_ID')
  Reference locator;

  @JsonKey(name: 'M_Locator_New_ID')
  Reference locatorTo;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  Reference installBase;

  @JsonKey(name: 'BHP_ToolRequest_ID')
  Reference requestID;

  @JsonKey(name: 'M_TrxType')
  String trxtype;

  num qtyEntered;
  String datedoc, serNo;

  ToolsTrfLine(
      {required this.doctype,
      required this.locator,
      required this.locatorTo,
      required this.installBase,
      required this.qtyEntered,
      required this.requestID,
      required this.trxtype,
      required this.datedoc,
      required this.serNo});

  factory ToolsTrfLine.fromJson(Map<String, dynamic> json) =>
      _$ToolsTrfLineFromJson(json);
  Map<String, dynamic> toJson() => _$ToolsTrfLineToJson(this);

  @override
  List<Object> get props => [doctype];

  @override
  String toString() {
    return 'ToolsTrfLine[doctype: $doctype]';
  }
}
