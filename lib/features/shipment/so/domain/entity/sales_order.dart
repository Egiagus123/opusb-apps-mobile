import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class SalesOrder extends BaseEntity {
  final String? documentNo;
  final ReferenceEntity? docStatus;

  @JsonKey(name: 'C_BPartner_ID')
  final ReferenceEntity? businessPartner;

  @JsonKey(name: 'C_BPartner_Location_ID')
  final ReferenceEntity? businessPartnerLocation;

  @JsonKey(name: 'C_DocType_ID')
  final ReferenceEntity? docType;

  @JsonKey(name: 'C_DocTypeTarget_ID')
  final ReferenceEntity? docTypeTarget;

  final String? description;
  final String? dateOrdered;
  final String? datePromised;
  final String? dateAcct;

  @JsonKey(name: 'AD_OrgTrx_ID')
  final ReferenceEntity? orgTrx;

  @JsonKey(name: 'User1_ID')
  final ReferenceEntity? user1;

  @JsonKey(name: 'C_Project_ID')
  final ReferenceEntity? project;

  @JsonKey(name: 'C_PaymentTerm_ID')
  final ReferenceEntity? paymentTerm;

  @JsonKey(name: 'C_Currency_ID')
  final ReferenceEntity? currency;

  @JsonKey(name: 'M_Warehouse_ID')
  final ReferenceEntity? warehouse;

  final String? chargeAmt;
  final ReferenceEntity? deliveryRule;
  final ReferenceEntity? deliveryViaRule;
  final ReferenceEntity? priorityRule;
  final String? freightAmt;
  final ReferenceEntity? freightCostRule;
  final ReferenceEntity? paymentRule;

  @JsonKey(name: 'SalesRep_ID')
  final ReferenceEntity? salesRepresentative;

  final bool? isDropShip;
  final bool? isSoTrx;

  SalesOrder(
      {@required int? id,
      ReferenceEntity? client,
      ReferenceEntity? organization,
      @required this.documentNo,
      @required this.businessPartner,
      @required this.businessPartnerLocation,
      @required this.docStatus,
      @required this.docType,
      @required this.docTypeTarget,
      @required this.description,
      @required this.dateOrdered,
      @required this.datePromised,
      @required this.dateAcct,
      @required this.paymentTerm,
      this.orgTrx,
      this.user1,
      this.project,
      @required this.currency,
      @required this.warehouse,
      @required this.chargeAmt,
      @required this.deliveryRule,
      @required this.deliveryViaRule,
      @required this.priorityRule,
      @required this.freightAmt,
      @required this.freightCostRule,
      @required this.paymentRule,
      @required this.salesRepresentative,
      this.isDropShip = false,
      this.isSoTrx = false})
      : super(id: id!, client: client!, organization: organization!);
}
