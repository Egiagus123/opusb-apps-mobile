import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pmbacklog.g.dart';

@JsonSerializable()
class PMBacklogModel extends Equatable {
  final String equipmentnumber,
      equipmentname,
      pmtype,
      scheduledDate,
      assignedwostatus,
      lastCompletionDate,
      intervalDays,
      assignedwo;
  final Reference bhpMInstallBaseID,
      bhpMPMTypeID,
      pMStatus,
      bhpPMScheduleID,
      bhpWOServiceID;

  PMBacklogModel(
      {required this.assignedwostatus,
      required this.lastCompletionDate,
      required this.equipmentname,
      required this.equipmentnumber,
      required this.pmtype,
      required this.bhpMInstallBaseID,
      required this.intervalDays,
      required this.bhpMPMTypeID,
      required this.pMStatus,
      required this.bhpPMScheduleID,
      required this.bhpWOServiceID,
      required this.scheduledDate,
      required this.assignedwo});

  factory PMBacklogModel.fromJson(Map<String, dynamic> json) =>
      _$PMBacklogModelFromJson(json);
  Map<String, dynamic> toJson() => _$PMBacklogModelToJson(this);

  @override
  List<Object> get props => [equipmentnumber];

  @override
  String toString() {
    return 'PMBacklogModel[equipmentnumber: $equipmentnumber]';
  }
}
