import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
part 'locator.g.dart';

@JsonSerializable()
class Locator {
  final int id;
  final String uid;
  @JsonKey(name: 'M_Warehouse_ID')
  final Reference warehouse;
  final String value;

  Locator({
    required this.id,
    required this.uid,
    required this.warehouse,
    required this.value,
  });

  factory Locator.fromJson(Map<String, dynamic> json) =>
      _$LocatorFromJson(json);

  Map<String, dynamic> toJson() => _$LocatorToJson(this);

  @override
  String toString() {
    return 'Locator[id: $id, value: $value]';
  }
}
