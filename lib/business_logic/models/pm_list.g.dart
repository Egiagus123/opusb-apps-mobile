// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pm_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PMSListModel $PMSListModelFromJson(Map<String, dynamic> json) {
  return PMSListModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Client_ID'] as Map<String, dynamic>),
    org: json['AD_Org_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    pmStatus: json['PM_Status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['PM_Status'] as Map<String, dynamic>),
    bHPMPMTypeID: json['BHP_M_PM_Type_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_M_PM_Type_ID'] as Map<String, dynamic>),
    bhpMInstallBaseID: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    documentNo: json['documentNo'] as String,
    scheduledDate: json['nextSchedule'] as String? ?? '',
  );
}

Map<String, dynamic> $PMSListModelToJson(PMSListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'AD_Client_ID': instance.client,
      'AD_Org_ID': instance.org,
      'documentNo': instance.documentNo,
      'PM_Status': instance.pmStatus,
      'BHP_M_PM_Type_ID': instance.bHPMPMTypeID,
      'BHP_M_InstallBase_ID': instance.bhpMInstallBaseID,
      'nextSchedule': instance.scheduledDate,
    };
