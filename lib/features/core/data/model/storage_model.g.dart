// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageModel _$StorageModelFromJson(Map<String, dynamic> json) {
  return StorageModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceModel.defaultReference()
        : ReferenceModel.fromJson(json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceModel.defaultReference()
        : ReferenceModel.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    asi: json['M_AttributeSetInstance_ID'] == null
        ? ReferenceModel.defaultReference()
        : ReferenceModel.fromJson(
            json['M_AttributeSetInstance_ID'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StorageModelToJson(StorageModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client?.toJson());
  writeNotNull('AD_Org_ID', instance.organization?.toJson());
  val['M_AttributeSetInstance_ID'] = instance.asi?.toJson();
  return val;
}
