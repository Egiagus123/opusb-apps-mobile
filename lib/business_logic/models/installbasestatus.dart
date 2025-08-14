import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/json_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'installbasestatus.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class InstallBaseStatus extends Equatable {
  final int id;

  @JsonKey(name: 'AD_Client_ID')
  final Reference client;

  @JsonKey(name: 'BHP_M_InstallBase_ID')
  final Reference installBaseID;

  final Reference status;

  final String description;

  @JsonKey(name: 'C_BPartnerSR_ID')
  final Reference bpartnerSR;

  @JsonKey(name: 'Effective_Date')
  final DateTime effectivedate;

  InstallBaseStatus({
    required this.id,
    required this.client,
    required this.installBaseID,
    required this.effectivedate,
    required this.bpartnerSR,
    required this.status,
    required this.description,
  });

  factory InstallBaseStatus.fromJson(Map<String, dynamic> json) =>
      _$InstallBaseStatusFromJson(json);
  Map<String, dynamic> toJson() => _$InstallBaseStatusToJson(this);

  @override
  List<Object> get props => [
        id,
        client,
        installBaseID,
        effectivedate,
        bpartnerSR,
        status,
        description,
      ];

  @override
  String toString() {
    return 'InstallBaseStatus[id: $id]';
  }
}
