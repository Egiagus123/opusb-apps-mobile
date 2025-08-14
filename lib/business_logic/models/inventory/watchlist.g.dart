// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistModel _$WatchlistModelFromJson(Map<String, dynamic> json) {
  return WatchlistModel(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$WatchlistModelToJson(WatchlistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
