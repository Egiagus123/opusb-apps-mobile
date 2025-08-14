// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installbasestatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallBaseStatus _$InstallBaseStatusFromJson(Map<String, dynamic> json) {
  return InstallBaseStatus(
    id: json['id'] as int? ?? 0,
    client: json['AD_Client_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Client_ID'] as Map<String, dynamic>),
    installBaseID: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    effectivedate: const DateTimeJsonConverter()
        .fromJson(json['Effective_Date'] as String),
    bpartnerSR: json['C_BPartnerSR_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['C_BPartnerSR_ID'] as Map<String, dynamic>),
    status: json['status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['status'] as Map<String, dynamic>),
    description: json['description'] as String? ?? "",
  );
}

Map<String, dynamic> _$InstallBaseStatusToJson(InstallBaseStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'AD_Client_ID': instance.client,
      'BHP_M_InstallBase_ID': instance.installBaseID,
      'status': instance.status,
      'description': instance.description,
      'C_BPartnerSR_ID': instance.bpartnerSR,
      'Effective_Date':
          const DateTimeJsonConverter().toJson(instance.effectivedate),
    };
