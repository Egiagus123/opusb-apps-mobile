import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'id_name_pair.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  List<IdNamePair> clients;
  final String token;

  AuthResponse({
    required this.clients,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  String toString() {
    return 'AuthResponse[clients: $clients, token: $token]';
  }
}
