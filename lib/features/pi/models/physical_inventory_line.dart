import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/features/core/base/utils/json_converter.dart';

part 'physical_inventory_line.g.dart';

@JsonSerializable(includeIfNull: false)
class PhysicalInventoryLine {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'M_Inventory_ID')
  Reference? inventory;

  @JsonKey(name: 'M_Locator_ID')
  Reference? locator;

  @JsonKey(name: 'M_Product_ID')
  Reference? product;

  @JsonKey(name: 'M_AttributeSetInstance_ID')
  Reference? asi;

  @JsonKey(name: 'C_UOM_ID')
  Reference? uom;

  String? description;

  @JsonKey(required: true)
  num? qtyCount = 0;

  @JsonKey(toJson: toNull)
  num? qtyBook;

  @JsonKey(toJson: toNull)
  String? productValue;

  @JsonKey(toJson: toNull)
  String? productName;

  @JsonKey(toJson: toNull)
  String? upc;

  @JsonKey(toJson: toNull)
  String? lot;

  @JsonKey(toJson: toNull)
  String? serNo;

  @JsonKey(toJson: toNull)
  bool? isLot;

  @JsonKey(toJson: toNull)
  bool? isSerNo;

  @JsonKey(toJson: toNull)
  bool? isLotMandatory;

  @JsonKey(toJson: toNull)
  bool? isSerNoMandatory;

  @JsonKey(toJson: toNull)
  bool? isInDispute;

  bool? isChecked;

  String? get keywords =>
      '$productValue#$productName$upc#$lot#$serNo#$description';

  bool isValidAsi() {
    if ((isLotMandatory! || isSerNoMandatory!) && (asi?.id ?? 0) == 0) {
      return false;
    }

    return true;
  }

  PhysicalInventoryLine({
    required this.id,
    required this.inventory,
    required this.locator,
    this.product,
    this.asi,
    this.uom,
    this.description,
    this.qtyBook,
    required this.qtyCount,
    this.productValue,
    this.productName,
    this.upc,
    this.lot,
    this.serNo,
    // this.guaranteeDate,
    this.isLot,
    this.isSerNo,
    // this.isGuaranteeDate,
    this.isLotMandatory,
    this.isSerNoMandatory,
    // this.isGuaranteeDateMandatory,
    required this.isInDispute,
    this.isChecked = false,
  });

  factory PhysicalInventoryLine.fromJson(Map<String, dynamic> json) =>
      _$PhysicalInventoryLineFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalInventoryLineToJson(this);

  @override
  String toString() {
    return '$productValue PILine[id: $id, inventory: $inventory, locator: $locator, product: $product, qtyCount: $qtyCount]';
  }

  // void copyProductInfoFrom(PhysicalInventoryLine line) {
  //   uom = line.uom;
  //   productValue = line.productValue;
  //   productName = line.productName;
  //   upc = line.upc;
  //   lot = line.lot;
  //   serNo = line.serNo;
  //   isLot = line.isLot;
  //   isSerNo = line.isSerNo;
  //   isLotMandatory = line.isLotMandatory;
  //   isSerNoMandatory = line.isSerNoMandatory;
  // }
}
