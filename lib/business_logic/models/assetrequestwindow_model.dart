import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/json_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assetrequestwindow_model.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class AssetRequestModel extends Equatable {
  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'AD_Org_ID')
  final Reference org;

  final String documentNo, description, dateDoc, dateReceived;

  final DateTime dateRequired;

  @JsonKey(name: 'BHP_ToolRequest_ID')
  final Reference headerID;

  @JsonKey(name: 'C_DocType_ID')
  final Reference doctype;

  @JsonKey(name: 'C_BPartner_ID')
  final Reference bpartner;

  @JsonKey(name: 'AD_OrgTrx_ID')
  final Reference orgTrx;

  @JsonKey(name: 'User1_ID')
  final Reference businessunit;

  final Reference docStatus;

  @JsonKey(name: 'M_Locator_ID')
  final Reference locator;

  @JsonKey(name: 'C_BPartnerSR_New_ID')
  final Reference agent;

  @JsonKey(name: 'M_Locator_New_ID')
  final Reference locatorTo;

  AssetRequestModel({
    required this.agent,
    required this.bpartner,
    required this.businessunit,
    required this.client,
    required this.dateRequired,
    required this.description,
    required this.docStatus,
    required this.doctype,
    required this.documentNo,
    required this.locator,
    required this.locatorTo,
    required this.org,
    required this.orgTrx,
    required this.dateReceived,
    required this.dateDoc,
    required this.headerID,
  });

  factory AssetRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AssetRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetRequestModelToJson(this);

  @override
  List<Object> get props => [headerID];

  @override
  String toString() {
    return 'AssetRequestModel[headerID: $headerID]';
  }
}
