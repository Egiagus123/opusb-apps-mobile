import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: 'M_Product_ID')
  final int id;
  final String value;
  final String name;
  final String sku;
  final String upc;
  @JsonKey(name: 'C_UOM_ID')
  final Reference uom;
  final bool isLot;
  final bool isSerNo;
  final bool isGuaranteeDate;
  final bool isLotMandatory;
  final bool isSerNoMandatory;
  final bool isGuaranteeDateMandatory;

  bool get isAsi => isLot || isSerNo || isGuaranteeDate;
  bool get isAsiMandatory =>
      isLotMandatory || isSerNoMandatory || isGuaranteeDateMandatory;

  Product({
    required this.id,
    required this.value,
    required this.name,
    required this.sku,
    required this.upc,
    required this.uom,
    required this.isLot,
    required this.isSerNo,
    required this.isGuaranteeDate,
    required this.isLotMandatory,
    required this.isSerNoMandatory,
    required this.isGuaranteeDateMandatory,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    return 'Product[id: $id, name: $name]';
  }
}
