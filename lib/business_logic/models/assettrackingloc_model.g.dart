// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assettrackingloc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTrackingLocation _$AssetTrackingLocationFromJson(
    Map<String, dynamic> json) {
  return AssetTrackingLocation(
    id: json['id'] as int? ?? 0,
    value: json['value'] as String? ?? '',
  );
}

Map<String, dynamic> _$AssetTrackingLocationToJson(
        AssetTrackingLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
    };
