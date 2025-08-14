import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'currentdisplaymeter.g.dart';

@JsonSerializable()
class CurrentDisplayMeter extends Equatable {
  // final int id;
  final String documentDate;
  final double qty;
  final Reference bhpMInstallBaseID, bhpMeterReadingID, meterType;

  CurrentDisplayMeter({
    required this.bhpMInstallBaseID,
    required this.documentDate,
    required this.bhpMeterReadingID,
    required this.qty,
    required this.meterType,
  });

  factory CurrentDisplayMeter.fromJson(Map<String, dynamic> json) =>
      _$CurrentDisplayMeterFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentDisplayMeterToJson(this);

  @override
  List<Object> get props => [bhpMeterReadingID];

  @override
  String toString() {
    return 'CurrentDisplayMeter[bhpMeterReadingID: $bhpMeterReadingID,qty:$qty,bhpMInstallBaseID:$bhpMInstallBaseID,documentDate:$documentDate,meterType:$meterType]';
  }
}
