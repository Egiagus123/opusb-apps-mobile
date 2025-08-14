import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class OrderLine extends BaseEntity {
  final int? line;

  @JsonKey(name: 'M_Product_ID')
  final ReferenceEntity? product;

  @JsonKey(name: 'C_UOM_ID')
  final ReferenceEntity? uom;

  double? qtyEntered;
  double? qtyOrdered;
  double? qtyReserved;
  double? qtyDelivered;
  double? qtyInvoiced;
  bool? processed;

  @JsonKey(name: 'product_name')
  String? productName;

  @JsonKey(name: 'product_search_key')
  String? productKey;

  @JsonKey(name: 'M_Product_Category_ID')
  ReferenceEntity? productCategory;

  @JsonKey(name: 'M_AttributeSet_ID')
  ReferenceEntity? attributeSet;
  final bool? isLot;
  final bool? isLotMandatory;
  final bool? isSerNo;
  final bool? isSerNoMandatory;
  final bool? isGuaranteeDate;
  final bool? isGuaranteeDateMandatory;

  OrderLine(
      {@required int? id,
      @required ReferenceEntity? client,
      @required ReferenceEntity? organization,
      @required this.line,
      @required this.product,
      @required this.uom,
      @required this.qtyOrdered,
      @required this.qtyReserved,
      @required this.qtyDelivered,
      @required this.qtyInvoiced,
      @required this.qtyEntered,
      @required this.processed,
      @required this.attributeSet,
      @required this.productName,
      @required this.productKey,
      this.productCategory,
      @required this.isSerNo,
      @required this.isLot,
      @required this.isGuaranteeDate,
      @required this.isGuaranteeDateMandatory,
      @required this.isLotMandatory,
      @required this.isSerNoMandatory})
      : super(
          id: id!,
          client: client!,
          organization: organization!,
        );

  /// Get the actual reserved quantity.
  double get reservedQuantity {
    double result;

    if (qtyEntered == qtyOrdered) {
      result = qtyReserved!;
    } else {
      double uomRatio = qtyEntered! / qtyOrdered!;
      result = (uomRatio * qtyReserved!);
    }

    return result;
  }
}
