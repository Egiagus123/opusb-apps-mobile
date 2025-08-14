import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assetrequest_model.g.dart';

@JsonSerializable()
class AssetRequest extends Equatable {
  final int id;

  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'AD_Org_ID')
  final Reference org;

  final String documentNo, description, dateRequired;

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

  AssetRequest(
      {required this.id,
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
      required this.orgTrx});

  factory AssetRequest.fromJson(Map<String, dynamic> json) =>
      _$AssetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AssetRequestToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'AssetRequest[id: $id]';
  }
}
