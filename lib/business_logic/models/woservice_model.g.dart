// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'woservice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WOServiceModel _$WOServiceModelFromJson(Map<String, dynamic> json) {
  return WOServiceModel(
    bhpWOServiceID: json['BHP_WOService_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_WOService_ID'] as Map<String, dynamic>),
    mLocatorID: json['M_Locator_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    documentNo: json['documentNo'] as String,
    endDate: json['endDate'] as String,
    bparnertlocation: json['C_BPartner_Location_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['C_BPartner_Location_ID'] as Map<String, dynamic>),
    description: json['description'] as String,
    adUserID: json['AD_User_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_User_ID'] as Map<String, dynamic>),
    status: json['status'] as String,
    cDocTypeID: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
    bhpinstallbaseid: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    mproductid: json['M_Product_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Product_ID'] as Map<String, dynamic>),
    priorityRule: json['priorityRule'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['priorityRule'] as Map<String, dynamic>),
    wOStatus: json['wOStatus'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['wOStatus'] as Map<String, dynamic>),
    bpartnerid: json['C_BPartner_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_BPartner_ID'] as Map<String, dynamic>),
    startDate: json['startDate'] as String,
    bhpEmployeeGroupID: json['BHP_EmployeeGroup_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_EmployeeGroup_ID'] as Map<String, dynamic>),
    dateTrx: json['dateTrx'] as String,
  );
}

Map<String, dynamic> _$WOServiceModelToJson(WOServiceModel instance) =>
    <String, dynamic>{
      'BHP_WOService_ID': instance.bhpWOServiceID,
      'M_Product_ID': instance.mproductid,
      'priorityRule': instance.priorityRule,
      'documentNo': instance.documentNo,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'dateTrx': instance.dateTrx,
      'C_BPartner_Location_ID': instance.bparnertlocation,
      'status': instance.status,
      'description': instance.description,
      'C_DocType_ID': instance.cDocTypeID,
      'AD_User_ID': instance.adUserID,
      'BHP_M_InstallBase_ID': instance.bhpinstallbaseid,
      'wOStatus': instance.wOStatus,
      'C_BPartner_ID': instance.bpartnerid,
      'BHP_EmployeeGroup_ID': instance.bhpEmployeeGroupID,
      'M_Locator_ID': instance.mLocatorID,
    };
