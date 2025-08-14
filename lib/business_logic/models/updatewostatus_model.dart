import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'updatewostatus_model.g.dart';

@JsonSerializable()
class UpdateWOStatusModel {
  @JsonKey(name: 'wOStatus')
  final String wOStatus;
  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'BHP_WOService_ID')
  final Reference bhpWOServiceID;

  UpdateWOStatusModel({
    required this.wOStatus,
    required this.date,
    required this.bhpWOServiceID,
  });

  factory UpdateWOStatusModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateWOStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateWOStatusModelToJson(this);

  @override
  String toString() {
    return 'UpdateWOStatusModel[wOStatus=$wOStatus,date=$date,bhpWOServiceID=$bhpWOServiceID]';
  }
}
