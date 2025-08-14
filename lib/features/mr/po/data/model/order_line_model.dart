import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';

part 'order_line_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderLineModel extends OrderLine {
  OrderLineModel(
      {required int id,
      required ReferenceEntity client,
      required ReferenceEntity organization,
      required int line,
      required ReferenceEntity product,
      required ReferenceEntity uom,
      required double qtyOrdered,
      required double qtyReserved,
      required double qtyDelivered,
      required double qtyInvoiced,
      required double qtyEntered,
      required bool processed,
      ReferenceEntity? attributeSet,
      String? productName,
      String? productKey,
      ReferenceEntity? productCategory,
      bool isSerNo = false,
      bool isLot = false,
      bool isGuaranteeDate = false,
      bool isGuaranteeDateMandatory = false,
      bool isLotMandatory = false,
      bool isSerNoMandatory = false})
      : super(
            id: id,
            client: client,
            organization: organization,
            line: line,
            product: product,
            uom: uom,
            qtyOrdered: qtyOrdered,
            qtyReserved: qtyReserved,
            qtyDelivered: qtyDelivered,
            qtyInvoiced: qtyInvoiced,
            qtyEntered: qtyEntered,
            processed: processed,
            attributeSet: attributeSet!,
            productName: productName!,
            productKey: productKey!,
            productCategory: productCategory!,
            isSerNo: isSerNo,
            isLot: isLot,
            isGuaranteeDate: isGuaranteeDate,
            isGuaranteeDateMandatory: isGuaranteeDateMandatory,
            isLotMandatory: isLotMandatory,
            isSerNoMandatory: isSerNoMandatory);

  factory OrderLineModel.fromJson(Map<String, dynamic> json) =>
      _$OrderLineModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderLineModelToJson(this);
}
