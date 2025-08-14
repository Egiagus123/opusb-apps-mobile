import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'reference.dart';
part 'assettrackingstatus_model.g.dart';

@JsonSerializable()
class AssetTrackingStatus extends Equatable {
  @JsonKey(name: 'AD_Ref_List_ID')
  final Reference status;
  final String value;
  AssetTrackingStatus({required this.status, required this.value});

  factory AssetTrackingStatus.fromJson(Map<String, dynamic> json) =>
      _$AssetTrackingStatusFromJson(json);
  Map<String, dynamic> toJson() => _$AssetTrackingStatusToJson(this);

  @override
  List<Object> get props => [status, value];

  @override
  String toString() {
    return 'AssetTrackingStatus[status: $status, value=$value]';
  }
}
