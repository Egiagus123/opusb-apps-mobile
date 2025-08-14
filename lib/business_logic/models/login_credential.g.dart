// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCredential _$LoginCredentialFromJson(Map<String, dynamic> json) {
  return LoginCredential(
    userName: json['userName'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$LoginCredentialToJson(LoginCredential instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
    };
