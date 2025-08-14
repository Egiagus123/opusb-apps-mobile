// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertNote _$AlertNoteFromJson(Map<String, dynamic> json) {
  return AlertNote(
    note: json['AD_Note_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_Note_ID'] as Map<String, dynamic>),
    user: json['AD_User_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['AD_User_ID'] as Map<String, dynamic>),
    alertSubject: json['alertSubject'] as String,
    alertMessage: json['alertMessage'] as String,
    processed: json['processed'] as bool,
    updated: const DateTimeJsonConverter().fromJson(json['updated'] as String),
  );
}

Map<String, dynamic> _$AlertNoteToJson(AlertNote instance) => <String, dynamic>{
      'AD_Note_ID': instance.note,
      'AD_User_ID': instance.user,
      'alertSubject': instance.alertSubject,
      'alertMessage': instance.alertMessage,
      'processed': instance.processed,
      'updated': const DateTimeJsonConverter().toJson(instance.updated),
    };
