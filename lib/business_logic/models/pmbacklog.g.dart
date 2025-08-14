// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pmbacklog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PMBacklogModel _$PMBacklogModelFromJson(Map<String, dynamic> json) {
  return PMBacklogModel(
    assignedwostatus: json['assigned_wo_status'] as String? ?? "",
    lastCompletionDate: json['last_completed_date'] as String? ?? "",
    equipmentname: json['equipment_name'] as String? ?? "",
    equipmentnumber: json['equipment_number'] as String? ?? "",
    pmtype: json['pm_type'] as String? ?? "",
    bhpMInstallBaseID: json['BHP_M_InstallBase_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_M_InstallBase_ID'] as Map<String, dynamic>),
    intervalDays: json['Interval_Meter4'] as String? ?? "",
    bhpMPMTypeID: json['BHP_M_PM_Type_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_M_PM_Type_ID'] as Map<String, dynamic>),
    pMStatus: json['PM_Status'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['PM_Status'] as Map<String, dynamic>),
    bhpPMScheduleID: json['BHP_PM_Schedule_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(
            json['BHP_PM_Schedule_ID'] as Map<String, dynamic>),
    bhpWOServiceID: json['BHP_WOService_ID'] == null
        ? Reference.defaultReference()
        : Reference.fromJson(json['BHP_WOService_ID'] as Map<String, dynamic>),
    scheduledDate: json['Scheduled_Date'] as String? ?? "",
    assignedwo: json['assigned_wo'] as String? ?? "",
  );
}

Map<String, dynamic> _$PMBacklogModelToJson(PMBacklogModel instance) =>
    <String, dynamic>{
      'equipment_number': instance.equipmentnumber,
      'equipment_name': instance.equipmentname,
      'pm_type': instance.pmtype,
      'Scheduled_Date': instance.scheduledDate,
      'assigned_wo_status': instance.assignedwostatus,
      'last_completed_date': instance.lastCompletionDate,
      'Interval_Meter4': instance.intervalDays,
      'assigned_wo': instance.assignedwo,
      'BHP_M_InstallBase_ID': instance.bhpMInstallBaseID,
      'BHP_M_PM_Type_ID': instance.bhpMPMTypeID,
      'PM_Status': instance.pMStatus,
      'BHP_PM_Schedule_ID': instance.bhpPMScheduleID,
      'BHP_WOService_ID': instance.bhpWOServiceID,
    };
