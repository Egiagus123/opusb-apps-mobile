// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute_set_instance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributeSetInstanceModel _$AttributeSetInstanceModelFromJson(
    Map<String, dynamic> json) {
  return AttributeSetInstanceModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    attributeSet: json['M_AttributeSet_ID'] == null
        ? ReferenceEntity.defaultReference()
        : ReferenceEntity.fromJson(
            json['M_AttributeSet_ID'] as Map<String, dynamic>),
    description: json['description'] as String,
    lot: json['lot'] as String,
    serialNo: json['serNo'] as String,
  )..tableName = json['tableName'] as String;
}

Map<String, dynamic> _$AttributeSetInstanceModelToJson(
    AttributeSetInstanceModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client?.toJson());
  writeNotNull('AD_Org_ID', instance.organization?.toJson());
  val['M_AttributeSet_ID'] = instance.attributeSet?.toJson();
  val['description'] = instance.description;
  writeNotNull('lot', instance.lot);
  writeNotNull('serNo', instance.serialNo);
  val['tableName'] = instance.tableName;
  return val;
}
