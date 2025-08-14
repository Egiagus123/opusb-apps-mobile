import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saverecentitem.g.dart';

@JsonSerializable()
class SaveRecentItem {
  final String documentNo, name;

  final Reference cDoctypeid, bHPWOServiceID;

  SaveRecentItem(
      {required this.documentNo,
      required this.cDoctypeid,
      required this.name,
      required this.bHPWOServiceID});

  factory SaveRecentItem.fromJson(Map<String, dynamic> json) =>
      _$SaveRecentItemFromJson(json);

  Map<String, dynamic> toJson() => _$SaveRecentItemToJson(this);

  @override
  String toString() {
    return 'SaveRecentItem[documentNo=$documentNo,cDoctypeid=$cDoctypeid,name=$name,bHPWOServiceID=$bHPWOServiceID]';
  }
}
