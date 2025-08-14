import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pm_list.g.dart';

@JsonSerializable()
class PMSListModel extends Equatable {
  final int id;

  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'AD_Org_ID')
  final Reference org;

  final Reference pmStatus, bHPMPMTypeID, bhpMInstallBaseID;

  final String documentNo, scheduledDate;

  PMSListModel(
      {required this.id,
      required this.client,
      required this.org,
      required this.documentNo,
      required this.pmStatus,
      required this.bHPMPMTypeID,
      required this.bhpMInstallBaseID,
      required this.scheduledDate});

  factory PMSListModel.fromJson(Map<String, dynamic> json) =>
      $PMSListModelFromJson(json);
  Map<String, dynamic> toJson() => $PMSListModelToJson(this);

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'PMSListModel[id: $id,pmStatus:$pmStatus,bHPMPMTypeID: $bHPMPMTypeID,bhpMInstallBaseID:$bhpMInstallBaseID,documentNo:$documentNo,scheduledDate:$scheduledDate]';
  }
}
