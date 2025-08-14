import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/json_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

// import '../utils/json_converter.dart';

part 'alert_note.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class AlertNote extends Equatable {
  @JsonKey(name: 'AD_Note_ID')
  final Reference note;
  @JsonKey(name: 'AD_User_ID')
  final Reference user;
  final String alertSubject;
  final String alertMessage;
  final bool processed;
  final DateTime updated;

  AlertNote({
    required this.note,
    required this.user,
    required this.alertSubject,
    required this.alertMessage,
    required this.processed,
    required this.updated,
  });

  @override
  List<Object> get props => [
        note,
        user,
        alertSubject,
        alertMessage,
        processed,
        updated,
      ];

  factory AlertNote.fromJson(Map<String, dynamic> json) =>
      _$AlertNoteFromJson(json);

  Map<String, dynamic> toJson() => _$AlertNoteToJson(this);
}
