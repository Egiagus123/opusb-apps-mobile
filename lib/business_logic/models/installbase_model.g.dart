// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installbase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallBaseModel _$InstallBaseModelFromJson(Map<String, dynamic> json) {
  return InstallBaseModel(
    id: json['id'] as int? ?? 0,
    documentNo: json['documentNo'] as String? ?? "",
    dateDisposed: json['dateDisposed'] as String? ?? "",
    effectivedate: json['Effective_Date'] as String? ?? "",
    serNo: json['serNo'] as String? ?? "",
    asset: json['A_Asset_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['A_Asset_ID'] as Map<String, dynamic>),
    status: json['status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['status'] as Map<String, dynamic>),
    description: json['description'] as String? ?? "",
    locator: json['M_Locator_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['M_Locator_ID'] as Map<String, dynamic>),
    qtyEntered: json['qtyEntered'] as int? ?? 0,
    bhpMInstallBaseTypeID: json['BHP_M_InstallBase_Type_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_Type_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$InstallBaseModelToJson(InstallBaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentNo': instance.documentNo,
      'dateDisposed': instance.dateDisposed,
      'Effective_Date': instance.effectivedate,
      'A_Asset_ID': instance.asset,
      'serNo': instance.serNo,
      'status': instance.status,
      'description': instance.description,
      'M_Locator_ID': instance.locator,
      'BHP_M_InstallBase_Type_ID': instance.bhpMInstallBaseTypeID,
      'qtyEntered': instance.qtyEntered,
    };
