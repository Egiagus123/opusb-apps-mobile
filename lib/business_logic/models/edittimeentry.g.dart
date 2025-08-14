// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edittimeentry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditTimeEntry _$EditTimeEntryFromJson(Map<String, dynamic> json) {
  return EditTimeEntry(
    description: json['description'] as String,
    qtyDelivered: (json['qtyDelivered'] as num).toDouble(),
    actualDate: json['actualDate'] as String,
  );
}

Map<String, dynamic> _$EditTimeEntryToJson(EditTimeEntry instance) =>
    <String, dynamic>{
      'actualDate': instance.actualDate,
      'description': instance.description,
      'qtyDelivered': instance.qtyDelivered,
    };
