import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'id_name_pair.g.dart';

@JsonSerializable()
class IdNamePair {
  final int id;
  final String name;

  IdNamePair({
    required this.id,
    required this.name,
  });

  factory IdNamePair.fromJson(Map<String, dynamic> json) =>
      _$IdNamePairFromJson(json);

  Map<String, dynamic> toJson() => _$IdNamePairToJson(this);

  @override
  String toString() {
    return 'IdNamePair[id: $id, name: $name]';
  }
}
