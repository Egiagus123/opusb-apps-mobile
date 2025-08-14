import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'savewoservice_model.g.dart';

@JsonSerializable()
class SaveWOServiceModel {
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'priorityRule')
  final String priorityRule;
  @JsonKey(name: 'startDate')
  final String startDate;
  @JsonKey(name: 'endDate')
  final String endDate;

  @JsonKey(name: 'C_BPartner_ID')
  final Reference cBPartnerID;

  @JsonKey(name: 'C_DocType_ID')
  final Reference cDoctypeid;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference bhpinstallbaseid;

  @JsonKey(name: 'C_BPartner_Location_ID')
  final Reference bplocationid;

  @JsonKey(name: 'BHP_EmployeeGroup_ID')
  final Reference employeegroupid;

  SaveWOServiceModel({
    required this.description,
    required this.priorityRule,
    required this.startDate,
    required this.endDate,
    required this.cBPartnerID,
    required this.bhpinstallbaseid,
    required this.employeegroupid,
    required this.bplocationid,
    required this.cDoctypeid,
  });

  factory SaveWOServiceModel.fromJson(Map<String, dynamic> json) =>
      _$SaveWOServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveWOServiceModelToJson(this);

  @override
  String toString() {
    return 'SaveWOServiceModel[description=$description,priorityRule=$priorityRule,startDate=$startDate,endDate=$endDate,cBPartnerID=$cBPartnerID,bhpinstallbaseid=$bhpinstallbaseid,employeegroupid=$employeegroupid,bplocationid=$bplocationid,cDoctypeid=$cDoctypeid]';
  }
}
