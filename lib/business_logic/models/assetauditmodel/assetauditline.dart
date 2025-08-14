// import 'package:eam_mobile/business_logic/utils/json_converter.dart';
// ignore_for_file: must_be_immutable

import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/json_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:eam_mobile/business_logic/models/reference.dart';

part 'assetauditline.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class AssetAuditLines extends Equatable {
  final int id;
  final String name;
  String note;
  @JsonKey(name: 'A_Asset_Status', includeIfNull: false)
  final Reference status;

  @JsonKey(name: 'BHP_AssetAudit_ID', includeIfNull: false)
  final Reference idHeader;

  @JsonKey(name: 'Audit_Asset_Status')
  Reference auditStatus;

  @JsonKey(name: 'M_AttributeSetInstance_ID', includeIfNull: false)
  final Reference attributeSet;

  final String assetActivationDate;
  final DateTime updated;

  @JsonKey(name: 'A_QTY_Current', includeIfNull: false)
  final String qty;

  @JsonKey(name: 'M_Product_ID', includeIfNull: false)
  final Reference product;

  @JsonKey(name: 'A_Asset_ID', includeIfNull: false)
  final Reference asset;

  num qtyCount;
  String assetvalue, assetname, assetstatus;

  AssetAuditLines({
    required this.id,
    required this.status,
    required this.name,
    required this.note,
    required this.attributeSet,
    required this.assetActivationDate,
    required this.qty,
    required this.product,
    required this.asset,
    required this.auditStatus,
    required this.idHeader,
    required this.updated,
    required this.qtyCount,
    required this.assetvalue,
    required this.assetname,
    required this.assetstatus,
  });

  factory AssetAuditLines.fromJson(Map<String, dynamic> json) =>
      _$AssetAuditLinesFromJson(json);
  Map<String, dynamic> toJson() => _$AssetAuditLinesToJson(this);

  @override
  List<Object> get props => [id, status, attributeSet];

  @override
  String toString() {
    return 'AssetAuditLines[id: $id, auditStatus: $status]';
  }
}
