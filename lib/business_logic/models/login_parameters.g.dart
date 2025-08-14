// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginParameters _$LoginParametersFromJson(Map<String, dynamic> json) {
  return LoginParameters(
    clientId: json['clientId'] as int,
    roleId: json['roleId'] as int,
    organizationId: json['organizationId'] as int,
    warehouseId: json['warehouseId'] as int,
  );
}

Map<String, dynamic> _$LoginParametersToJson(LoginParameters instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'roleId': instance.roleId,
      'organizationId': instance.organizationId,
      'warehouseId': instance.warehouseId,
    };
