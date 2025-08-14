// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bplocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BPLocationModel _$BPLocationModelFromJson(Map<String, dynamic> json) {
  return BPLocationModel(
    id: json['id'] as int,
    name: json['name'] as String,
    bpartnerid: json['bpartnerid'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['bpartnerid'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BPLocationModelToJson(BPLocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bpartnerid': instance.bpartnerid,
    };
