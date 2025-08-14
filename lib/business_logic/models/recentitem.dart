import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recentitem.g.dart';

@JsonSerializable()
class RecentItem {
  final String name, created;

  final Reference cDoctypeid, createdBy, bhpwoserviceid, bhpmeterreadingid;

  RecentItem(
      {required this.bhpwoserviceid,
      required this.bhpmeterreadingid,
      required this.cDoctypeid,
      required this.name,
      required this.created,
      required this.createdBy});

  factory RecentItem.fromJson(Map<String, dynamic> json) =>
      _$RecentItemFromJson(json);

  Map<String, dynamic> toJson() => _$RecentItemToJson(this);

  @override
  String toString() {
    return 'RecentItem[bhpwoserviceid=$bhpwoserviceid,bhpmeterreadingid=$bhpmeterreadingid,cDoctypeid=$cDoctypeid,name=$name,created=$created,createdBy=$createdBy]';
  }
}
