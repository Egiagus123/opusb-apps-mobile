import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saveworequest_model.g.dart';

@JsonSerializable()
class SaveWORequestModel {
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'requestedDate')
  final String requestedDate;
  @JsonKey(name: 'startDate')
  final String startDate;
  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference bhpinstallbaseid;
  @JsonKey(name: 'C_DocType_ID')
  final Reference cDoctypeid;
  @JsonKey(name: 'endDate')
  final String endDate;
  @JsonKey(name: 'priorityRule')
  final String priorityRule;

  SaveWORequestModel({
    required this.description,
    required this.priorityRule,
    required this.startDate,
    required this.endDate,
    required this.requestedDate,
    required this.bhpinstallbaseid,
    required this.cDoctypeid,
  });

  factory SaveWORequestModel.fromJson(Map<String, dynamic> json) =>
      _$SaveWORequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveWORequestModelToJson(this);

  @override
  String toString() {
    return 'SaveWORequestModel[description=$description,bhpinstallbaseid=$bhpinstallbaseid]';
  }
}
