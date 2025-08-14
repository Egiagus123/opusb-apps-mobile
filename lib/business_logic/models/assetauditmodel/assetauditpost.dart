// import 'package:equatable/equatable.dart';
// import 'package:json_annotation/json_annotation.dart';
// import '../reference.dart';
// part 'assetauditpost.g.dart';

// @JsonSerializable()
// class AssetAuditPost extends Equatable {
//   @JsonKey(name: 'AD_Org_ID')
//   Reference org;
//   @JsonKey(name: 'Audit_Asset_Status')
//   Reference auditStatus;
//   num qtyCount;
//   String note;
//   bool isAudited;
//   factory AssetAuditPost.fromJson(Map<String, dynamic> json) =>
//       _$AssetAuditPostFromJson(json);
//   Map<String, dynamic> toJson() => _$AssetAuditPostToJson(this);
//   AssetAuditPost(
//       {this.auditStatus, this.note, this.qtyCount, this.isAudited, this.org});

//   @override
//   List<Object> get props => [
//         auditStatus,
//         note,
//         qtyCount,
//         isAudited,
//         org,
//       ];
// }
