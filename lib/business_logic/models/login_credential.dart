import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'login_credential.g.dart';

@JsonSerializable()
class LoginCredential {
  final String userName;
  final String password;

  LoginCredential({
    required this.userName,
    required this.password,
  });

  factory LoginCredential.fromJson(Map<String, dynamic> json) =>
      _$LoginCredentialFromJson(json);

  Map<String, dynamic> toJson() => _$LoginCredentialToJson(this);

  @override
  String toString() {
    return 'LoginCredential[userName: $userName, password: $password]';
  }
}
