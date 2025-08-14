// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saveworequest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveWORequestModel _$SaveWORequestModelFromJson(Map<String, dynamic> json) {
  return SaveWORequestModel(
    description: json['description'] as String,
    priorityRule: json['priorityRule'] as String,
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String,
    requestedDate: json['requestedDate'] as String,
    bhpinstallbaseid: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    cDoctypeid: json['C_DocType_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_DocType_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SaveWORequestModelToJson(SaveWORequestModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'requestedDate': instance.requestedDate,
      'startDate': instance.startDate,
      'BHP_M_InstallBase_ID': instance.bhpinstallbaseid,
      'C_DocType_ID': instance.cDoctypeid,
      'endDate': instance.endDate,
      'priorityRule': instance.priorityRule,
    };
