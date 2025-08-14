import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:eam_mobile/business_logic/models/reference.dart';

part 'assetauditheader.g.dart';

@JsonSerializable()
class AssetAuditHeader extends Equatable {
  final int id;
  final String documentNo, date1;

  @JsonKey(name: 'C_DocType_ID')
  final Reference docType;

  @JsonKey(name: 'M_Locator_ID')
  final Reference locator;

  final Reference docStatus;

  AssetAuditHeader({
    required this.id,
    required this.documentNo,
    required this.date1,
    required this.docType,
    required this.locator,
    required this.docStatus,
  });

  factory AssetAuditHeader.fromJson(Map<String, dynamic> json) =>
      _$AssetAuditHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$AssetAuditHeaderToJson(this);

  @override
  List<Object> get props => [id, documentNo];

  @override
  String toString() {
    return 'AssetAuditHeader[id: $id, value: $documentNo]';
  }
}
