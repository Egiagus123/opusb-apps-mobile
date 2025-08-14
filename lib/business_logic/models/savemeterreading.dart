import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'savemeterreading.g.dart';

@JsonSerializable()
class SaveMeterReading {
  final String documentDate;

  final Reference cDoctypeid, bhpinstallbaseid, meterType, adOrgID;

  final double qty;

  SaveMeterReading(
      {required this.documentDate,
      required this.bhpinstallbaseid,
      required this.cDoctypeid,
      required this.meterType,
      required this.qty,
      required this.adOrgID});

  factory SaveMeterReading.fromJson(Map<String, dynamic> json) =>
      _$SaveMeterReadingFromJson(json);

  Map<String, dynamic> toJson() => _$SaveMeterReadingToJson(this);

  @override
  String toString() {
    return 'SaveMeterReading[documentDate=$documentDate,bhpinstallbaseid=$bhpinstallbaseid,cDoctypeid=$cDoctypeid,meterType=$meterType,qty:$qty]';
  }
}
