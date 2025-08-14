import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

part 'sales_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalesOrderModel extends SalesOrder {
  SalesOrderModel(
      {@required int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      @required String? documentNo,
      @required ReferenceEntity? businessPartner,
      @required ReferenceEntity? businessPartnerLocation,
      @required ReferenceEntity? docStatus,
      @required ReferenceEntity? docType,
      @required ReferenceEntity? docTypeTarget,
      @required String? description,
      @required String? dateOrdered,
      @required String? datePromised,
      @required String? dateAcct,
      ReferenceEntity? orgTrx,
      ReferenceEntity? user1,
      ReferenceEntity? project,
      @required ReferenceEntity? paymentTerm,
      @required ReferenceEntity? currency,
      @required ReferenceEntity? warehouse,
      @required String? chargeAmt,
      @required ReferenceEntity? deliveryRule,
      @required ReferenceEntity? deliveryViaRule,
      @required ReferenceEntity? priorityRule,
      @required String? freightAmt,
      @required ReferenceEntity? freightCostRule,
      @required ReferenceEntity? paymentRule,
      ReferenceEntity? salesRepresentative,
      bool isDropShip = false,
      bool isSoTrx = false})
      : super(
            id: id!,
            client: client!,
            organization: organization!,
            documentNo: documentNo!,
            businessPartner: businessPartner!,
            businessPartnerLocation: businessPartnerLocation!,
            docStatus: docStatus!,
            docType: docType!,
            docTypeTarget: docTypeTarget!,
            description: description!,
            dateOrdered: dateOrdered!,
            datePromised: datePromised!,
            dateAcct: dateAcct!,
            orgTrx: orgTrx!,
            user1: user1!,
            project: project!,
            paymentTerm: paymentTerm!,
            currency: currency!,
            warehouse: warehouse!,
            chargeAmt: chargeAmt!,
            deliveryRule: deliveryRule!,
            deliveryViaRule: deliveryViaRule!,
            priorityRule: priorityRule!,
            freightAmt: freightAmt!,
            freightCostRule: freightCostRule!,
            paymentRule: paymentRule!,
            salesRepresentative: salesRepresentative!,
            isDropShip: isDropShip,
            isSoTrx: isSoTrx);

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$SalesOrderModelToJson(this);
}
