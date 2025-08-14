import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'login_parameters.g.dart';

@JsonSerializable()
class LoginParameters {
  final int clientId;
  final int roleId;
  final int organizationId;
  final int warehouseId;

  LoginParameters({
    required this.clientId,
    required this.roleId,
    this.organizationId = 0,
    this.warehouseId = 0,
  });

  factory LoginParameters.fromJson(Map<String, dynamic> json) =>
      _$LoginParametersFromJson(json);

  Map<String, dynamic> toJson() => _$LoginParametersToJson(this);

  @override
  String toString() {
    return 'LoginParameters[clientId: $clientId, roleId: $roleId]';
  }
}
