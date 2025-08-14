import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/features/core/base/utils/json_converter.dart';
part 'physical_inventory.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class PhysicalInventory {
  final int id;
  final String uid;
  final String documentNo;
  final DateTime movementDate;
  @JsonKey(name: 'M_Warehouse_ID')
  final Reference warehouse;
  final Reference docStatus;
  final bool processed;

  PhysicalInventory({
    required this.id,
    required this.uid,
    required this.documentNo,
    required this.movementDate,
    required this.warehouse,
    required this.docStatus,
    required this.processed,
  });

  factory PhysicalInventory.fromJson(Map<String, dynamic> json) =>
      _$PhysicalInventoryFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalInventoryToJson(this);

  @override
  String toString() {
    return 'PI[id: $id, documentNo: $documentNo]';
  }
}
