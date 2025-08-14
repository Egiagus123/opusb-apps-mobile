import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'editrequestdate.g.dart';

@JsonSerializable()
class EditRequestDate {
  @JsonKey(name: 'requestedDate')
  final String requestedDate;

  EditRequestDate({
    required this.requestedDate,
  });

  factory EditRequestDate.fromJson(Map<String, dynamic> json) =>
      _$EditRequestDateFromJson(json);

  Map<String, dynamic> toJson() => _$EditRequestDateToJson(this);

  @override
  String toString() {
    return 'EditRequestDate[requestedDate=$requestedDate]';
  }
}
