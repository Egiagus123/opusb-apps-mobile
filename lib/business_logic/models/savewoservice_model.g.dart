// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savewoservice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveWOServiceModel _$SaveWOServiceModelFromJson(Map<String, dynamic> json) {
  return SaveWOServiceModel(
    description: json['description'] as String,
    priorityRule: json['priorityRule'] as String,
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String,
    cBPartnerID: json['C_BPartner_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_BPartner_ID'] as Map<String, dynamic>),
    bhpinstallbaseid: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    employeegroupid: json['BHP_EmployeeGroup_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_EmployeeGroup_ID'] as Map<String, dynamic>),
    bplocationid: json['C_BPartner_Location_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['C_BPartner_Location_ID'] as Map<String, dynamic>),
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SaveWOServiceModelToJson(SaveWOServiceModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'priorityRule': instance.priorityRule,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'C_BPartner_ID': instance.cBPartnerID,
      'C_DocType_ID': instance.cDoctypeid,
      'BHP_M_InstallBase_ID': instance.bhpinstallbaseid,
      'C_BPartner_Location_ID': instance.bplocationid,
      'BHP_EmployeeGroup_ID': instance.employeegroupid,
    };
