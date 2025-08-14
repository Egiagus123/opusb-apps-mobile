// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeentry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeEntryModel _$TimeEntryModelFromJson(Map<String, dynamic> json) {
  return TimeEntryModel(
    bhpResourceAssignmentID: json['BHP_ResourceAssignment_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_ResourceAssignment_ID'] as Map<String, dynamic>),
    description: json['description'] as String? ?? '',
    startDate: json['startDate'] as String? ?? '',
    endDate: json['endDate'] as String? ?? '',
    bhpEmployeeGroupID: json['BHP_EmployeeGroup_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_EmployeeGroup_ID'] as Map<String, dynamic>),
    bhpWOServiceID: json['BHP_WOService_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_WOService_ID'] as Map<String, dynamic>),
    bhpEmployeeID: json['BHP_Employee_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_Employee_ID'] as Map<String, dynamic>),
    qtyDelivered: (json['qtyDelivered'] as num).toDouble(),
    qtyEntered: (json['qtyEntered'] as num).toDouble(),
    actualDate: json['actualDate'] as String? ?? '',
  );
}

Map<String, dynamic> _$TimeEntryModelToJson(TimeEntryModel instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'actualDate': instance.actualDate,
      'description': instance.description,
      'qtyEntered': instance.qtyEntered,
      'qtyDelivered': instance.qtyDelivered,
      'BHP_EmployeeGroup_ID ': instance.bhpEmployeeGroupID,
      'BHP_Employee_ID': instance.bhpEmployeeID,
      'BHP_WOService_ID': instance.bhpWOServiceID,
      'BHP_ResourceAssignment_ID': instance.bhpResourceAssignmentID,
    };
