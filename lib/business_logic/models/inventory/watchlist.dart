import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'watchlist.g.dart';

@JsonSerializable()
class WatchlistModel extends Equatable {
  final int id;
  final String name;

  WatchlistModel({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];

  factory WatchlistModel.fromJson(Map<String, dynamic> json) =>
      _$WatchlistModelFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistModelToJson(this);
}
