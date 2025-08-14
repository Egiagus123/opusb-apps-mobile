import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrfline.dart';
// import 'package:eam_mobile/business_logic/models/assettrfmodel/generatetoolstrfline.dart';
// import 'package:eam_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../reference.dart';
part 'generatetoolstrf.g.dart';

@JsonSerializable()
class GenerateData extends Equatable {
  @JsonKey(name: 'AD_Org_ID')
  final Reference orgID;

  @JsonKey(nullable: true, includeIfNull: false)
  String? documentNo;

  final String dateDoc;

  @JsonKey(name: 'C_DocType_ID')
  final Reference doctype;

  @JsonKey(name: 'M_Locator_ID')
  final Reference locatorFrom;

  @JsonKey(name: 'M_Locator_New_ID')
  final Reference locatorToInTransit;

  @JsonKey(name: 'BHP_ToolRequest_ID')
  final Reference toolRequest;

  final Reference docStatus;

  final List<GenerateDataLine> detail;

  GenerateData(
      {required this.orgID,
      this.documentNo,
      required this.dateDoc,
      required this.doctype,
      required this.locatorFrom,
      required this.locatorToInTransit,
      required this.toolRequest,
      required this.docStatus,
      required this.detail});
  factory GenerateData.fromJson(Map<String, dynamic> json) =>
      _$GenerateDataFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateDataToJson(this);

  @override
  List<Object> get props => [
        dateDoc,
        docStatus,
        locatorFrom,
        locatorToInTransit,
        toolRequest,
        docStatus,
        detail
      ];

  @override
  String toString() {
    return 'GenerateData[ '
        'dateDoc: $dateDoc, '
        'docStatus:$docStatus, '
        'locatorFrom: $locatorFrom '
        'locatorToInTransit: $locatorToInTransit '
        'toolRequest:$toolRequest, '
        'docStatus: $docStatus, '
        'detail: $detail ]';
  }
}
