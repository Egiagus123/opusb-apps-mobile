import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String client_name;
  final String role_name;
  final String value;
  @JsonKey(name: 'AD_Image_ID')
  final Reference image;
  final String binaryData;

  UserData(
      {required this.client_name,
      required this.role_name,
      required this.value,
      required this.image,
      required this.binaryData});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() {
    return 'UserData[clientId: $client_name, roleId: $role_name]';
  }

  static List<UserData> listFromJson(List<dynamic> json) {
    json.map((a) => print(a));
    return json.map((e) => UserData.fromJson(e)).toList();
  }
}
