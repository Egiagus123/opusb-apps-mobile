import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meterreading.g.dart';

@JsonSerializable()
class MeterReading {
  final String created;
  final int id;

  final Reference cDoctypeid, createdBy, bHPMInstallBaseID;

  MeterReading(
      {required this.bHPMInstallBaseID,
      required this.cDoctypeid,
      required this.id,
      required this.created,
      required this.createdBy});

  factory MeterReading.fromJson(Map<String, dynamic> json) =>
      _$MeterReadingFromJson(json);

  Map<String, dynamic> toJson() => _$MeterReadingToJson(this);

  @override
  String toString() {
    return 'MeterReading[bHPMInstallBaseID=$bHPMInstallBaseID,cDoctypeid=$cDoctypeid,id=$id,created=$created,createdBy=$createdBy]';
  }
}
