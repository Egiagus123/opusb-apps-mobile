// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocatorModel _$LocatorModelFromJson(Map<String, dynamic> json) {
  return LocatorModel(
    id: json['id'] as int,
    client: json['AD_Client_ID'] == null
        ? null
        : ReferenceEntity.fromJson(
            json['AD_Client_ID'] as Map<String, dynamic>),
    organization: json['AD_Org_ID'] == null
        ? null
        : ReferenceEntity.fromJson(json['AD_Org_ID'] as Map<String, dynamic>),
    x: json['x'] as String,
    y: json['y'] as String,
    z: json['z'] as String,
    value: json['value'] as String,
    priorityNo: json['priorityNo'] as int,
    defaultLocator: json['defaultLocator'] as bool,
  );
}

Map<String, dynamic> _$LocatorModelToJson(LocatorModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('AD_Client_ID', instance.client?.toJson());
  writeNotNull('AD_Org_ID', instance.organization?.toJson());
  val['x'] = instance.x;
  val['y'] = instance.y;
  val['z'] = instance.z;
  val['value'] = instance.value;
  val['priorityNo'] = instance.priorityNo;
  val['defaultLocator'] = instance.defaultLocator;
  return val;
}
