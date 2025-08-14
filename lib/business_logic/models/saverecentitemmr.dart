import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saverecentitemmr.g.dart';

@JsonSerializable()
class SaveRecentItemMR {
  final String name;

  final Reference cDoctypeid, bHPmeterreadingID;

  SaveRecentItemMR(
      {required this.cDoctypeid,
      required this.name,
      required this.bHPmeterreadingID});

  factory SaveRecentItemMR.fromJson(Map<String, dynamic> json) =>
      _$SaveRecentItemMRFromJson(json);

  Map<String, dynamic> toJson() => _$SaveRecentItemMRToJson(this);

  @override
  String toString() {
    return 'SaveRecentItem[cDoctypeid=$cDoctypeid,name=$name,bHPmeterreadingID=$bHPmeterreadingID]';
  }
}
