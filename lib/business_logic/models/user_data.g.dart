// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    client_name: json['client_name'] as String,
    role_name: json['role_name'] as String,
    value: json['value'] as String,
    image: json['AD_Image_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Image_ID'] as Map<String, dynamic>),
    binaryData: json['binaryData'] as String,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'client_name': instance.client_name,
      'role_name': instance.role_name,
      'value': instance.value,
      'AD_Image_ID': instance.image,
      'binaryData': instance.binaryData,
    };
