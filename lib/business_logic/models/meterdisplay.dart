import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:json_annotation/json_annotation.dart';
part 'meterdisplay.g.dart';

@JsonSerializable()
class MeterTypeModel {
  final int id;
  final Reference adOrgID, meterType;

  MeterTypeModel(
      {required this.id, required this.meterType, required this.adOrgID});

  factory MeterTypeModel.fromJson(Map<String, dynamic> json) =>
      _$MeterTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeterTypeModelToJson(this);

  @override
  String toString() {
    return 'MeterTypeModel[meterType: $meterType, adOrgID: $adOrgID]';
  }
}
