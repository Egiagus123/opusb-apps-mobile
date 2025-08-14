// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assettrackingstatus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTrackingStatus _$AssetTrackingStatusFromJson(Map<String, dynamic> json) {
  return AssetTrackingStatus(
    status: json['AD_Ref_List_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Ref_List_ID'] as Map<String, dynamic>),
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$AssetTrackingStatusToJson(
        AssetTrackingStatus instance) =>
    <String, dynamic>{
      'AD_Ref_List_ID': instance.status,
      'value': instance.value,
    };
