import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'rendered.g.dart';

@JsonSerializable()
class Rendered extends Equatable {
  final String rendered;

  Rendered({
    required this.rendered,
  });

  factory Rendered.fromJson(Map<String, dynamic> json) =>
      _$RenderedFromJson(json);
  Map<String, dynamic> toJson() => _$RenderedToJson(this);

  @override
  List<Object> get props => [rendered, protected];

  @override
  String toString() {
    return 'Rendered[rendered: $rendered]';
  }

  factory Rendered.defaultReference() {
    return Rendered(
        rendered: ''); // Replace 'default' with your actual default value
  }
}
