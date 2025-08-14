// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updatewostatus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWOStatusModel _$UpdateWOStatusModelFromJson(Map<String, dynamic> json) {
  return UpdateWOStatusModel(
    wOStatus: json['wOStatus'] as String,
    date: json['date'] as String,
    bhpWOServiceID: json['BHP_WOService_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_WOService_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateWOStatusModelToJson(
        UpdateWOStatusModel instance) =>
    <String, dynamic>{
      'wOStatus': instance.wOStatus,
      'date': instance.date,
      'BHP_WOService_ID': instance.bhpWOServiceID,
    };
