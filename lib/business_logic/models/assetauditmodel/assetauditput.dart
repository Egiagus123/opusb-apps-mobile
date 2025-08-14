import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import '../reference.dart';
part 'assetauditput.g.dart';

@JsonSerializable()
class AssetAuditPut extends Equatable {
  @JsonKey(name: 'AD_Org_ID')
  Reference? org;
  @JsonKey(name: 'Audit_Asset_Status')
  Reference? auditStatus;
  @JsonKey(name: 'A_Asset_ID')
  Reference? asset;
  @JsonKey(name: 'BHP_AssetAudit_ID')
  Reference? headerID;
  num? qtyCount;
  String? note;
  bool? isAudited;

  @override
  String toString() {
    return 'AssetAuditPut[org: $org, auditStatus: $auditStatus,asset: $asset,headerID:$headerID,qtyCount:$qtyCount,note:$note,isAudited:$isAudited]';
  }

  factory AssetAuditPut.fromJson(Map<String, dynamic> json) =>
      _$AssetAuditPutFromJson(json);
  Map<String, dynamic> toJson() => _$AssetAuditPutToJson(this);
  AssetAuditPut(
      {@required this.auditStatus,
      @required this.headerID,
      @required this.note,
      @required this.qtyCount,
      @required this.isAudited,
      @required this.org,
      @required this.asset});

  @override
  List<Object> get props => [
        auditStatus!,
        note!,
        qtyCount!,
        isAudited!,
        org!,
        asset!,
        headerID!,
      ];
}
