// import 'package:eam_mobile/business_logic/models/reference.dart';
// import 'package:eam_mobile/business_logic/utils/json_converter.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/json_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'assetrcvdata_model.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class AssetRcvData extends Equatable {
  final int id;

  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'AD_Org_ID')
  final Reference org;

  final String documentNo,
      description,
      dateReceived,
      serNo,
      dateDoc,
      trfdatedoc,
      trfdocno;

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
  Reference locatorTo;

  final DateTime dateRequired;

  @JsonKey(name: 'BHP_ToolRequestLine_ID')
  final Reference requestLineID;

  final num qtyEntered;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference installbase;

  final int intransit;

  AssetRcvData(
      {required this.id,
      required this.agent,
      required this.bpartner,
      required this.businessunit,
      required this.client,
      required this.dateDoc,
      required this.dateRequired,
      required this.dateReceived,
      required this.description,
      required this.docStatus,
      required this.doctype,
      required this.documentNo,
      required this.locator,
      required this.locatorTo,
      required this.org,
      required this.orgTrx,
      required this.serNo,
      required this.requestLineID,
      required this.qtyEntered,
      required this.installbase,
      required this.intransit,
      required this.trfdatedoc,
      required this.trfdocno});

  factory AssetRcvData.fromJson(Map<String, dynamic> json) =>
      _$AssetRcvDataFromJson(json);
  Map<String, dynamic> toJson() => _$AssetRcvDataToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'AssetRcvData[id: $id]';
  }
}
