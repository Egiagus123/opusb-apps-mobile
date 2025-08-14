import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'timeentry.g.dart';

@JsonSerializable()
class TimeEntryModel extends Equatable {
  // final int id;
  final String startDate, endDate, actualDate, description;
  final double qtyEntered, qtyDelivered;
  final Reference bhpEmployeeGroupID,
      bhpEmployeeID,
      bhpWOServiceID,
      bhpResourceAssignmentID;

  TimeEntryModel(
      {required this.bhpResourceAssignmentID,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.bhpEmployeeGroupID,
      required this.bhpWOServiceID,
      required this.bhpEmployeeID,
      required this.qtyDelivered,
      required this.qtyEntered,
      required this.actualDate});

  factory TimeEntryModel.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeEntryModelToJson(this);

  @override
  List<Object> get props => [bhpResourceAssignmentID];

  @override
  String toString() {
    return 'TimeEntryModel[bhpResourceAssignmentID: $bhpResourceAssignmentID]';
  }
}
