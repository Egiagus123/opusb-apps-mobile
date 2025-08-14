import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'woservice_model.g.dart';

@JsonSerializable()
class WOServiceModel extends Equatable {
  @JsonKey(name: 'BHP_WOService_ID')
  final Reference bhpWOServiceID;

  @JsonKey(name: 'M_Product_ID')
  final Reference mproductid;

  @JsonKey(name: 'priorityRule')
  final Reference priorityRule;

  final String documentNo;

  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'startDate')
  final String startDate;

  @JsonKey(name: 'dateTrx')
  final String dateTrx;

  @JsonKey(name: 'C_BPartner_Location_ID')
  final Reference bparnertlocation;

  final String status;
  final String description;

  @JsonKey(name: 'C_DocType_ID')
  final Reference cDocTypeID;

  @JsonKey(name: 'AD_User_ID')
  final Reference adUserID;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference bhpinstallbaseid;

  @JsonKey(name: 'wOStatus')
  final Reference wOStatus;

  @JsonKey(name: 'C_BPartner_ID')
  final Reference bpartnerid;

  @JsonKey(name: 'BHP_EmployeeGroup_ID')
  final Reference bhpEmployeeGroupID;

  @JsonKey(name: 'M_Locator_ID')
  final Reference mLocatorID;

  WOServiceModel(
      {required this.bhpWOServiceID,
      required this.mLocatorID,
      required this.documentNo,
      required this.endDate,
      required this.bparnertlocation,
      required this.description,
      required this.adUserID,
      required this.status,
      required this.cDocTypeID,
      required this.bhpinstallbaseid,
      required this.mproductid,
      required this.priorityRule,
      required this.wOStatus,
      required this.bpartnerid,
      required this.startDate,
      required this.bhpEmployeeGroupID,
      required this.dateTrx});

  factory WOServiceModel.fromJson(Map<String, dynamic> json) =>
      _$WOServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WOServiceModelToJson(this);

  @override
  List<Object> get props => [
        bhpWOServiceID,
        endDate,
        adUserID,
        status,
        description,
        bparnertlocation,
        cDocTypeID,
        documentNo,
        bhpinstallbaseid
      ];

  @override
  String toString() {
    return 'WOServiceModel[bhpWOServiceID: $bhpWOServiceID]';
  }
}
