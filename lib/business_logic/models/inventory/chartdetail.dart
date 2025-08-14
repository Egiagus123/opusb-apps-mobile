import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chartdetail.g.dart';

@JsonSerializable()
class DataDetail extends Equatable {
  @JsonKey(name: 'YTDWorkOrder.wostatus')
  final String wostatus;
  @JsonKey(name: 'YTDWorkOrder.totalwo')
  final String totalwo;

  DataDetail({
    required this.wostatus,
    required this.totalwo,
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) =>
      _$DataDetailFromJson(json);
  Map<String, dynamic> toJson() => _$DataDetailToJson(this);

  @override
  List<Object> get props => [wostatus, totalwo];

  @override
  String toString() {
    return 'DataDetail[wostatus: $wostatus, totalwo: $totalwo]';
  }
}
