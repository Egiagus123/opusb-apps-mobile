part of 'woservice_cubit.dart';

abstract class WOServiceState extends Equatable {
  const WOServiceState();

  @override
  List<Object> get props => [];
}

class WOServiceInitial extends WOServiceState {}

class WOServiceLoadInProgress extends WOServiceState {}

class WOServiceSuccess extends WOServiceState {
  final List<WOServiceModel> listservice;

  const WOServiceSuccess({required this.listservice});

  @override
  List<Object> get props => [WOServiceSuccess];
}

class WOServiceFailure extends WOServiceState {
  final String message;

  const WOServiceFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class WOStatusSuccess extends WOServiceState {
  final List<WOStatusModel> wostatus;

  const WOStatusSuccess({required this.wostatus});

  @override
  List<Object> get props => [WOStatusSuccess];
}

class WOStatusFailure extends WOServiceState {
  final String message;

  const WOStatusFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class PrioritySuccess extends WOServiceState {
  final List<PriorityModel> priority;

  const PrioritySuccess({required this.priority});

  @override
  List<Object> get props => [PrioritySuccess];
}

class PriorityFailure extends WOServiceState {
  final String message;

  const PriorityFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class BPartnerSuccess extends WOServiceState {
  final List<BusinessPartnerModel> bpartner;

  const BPartnerSuccess({required this.bpartner});

  @override
  List<Object> get props => [BPartnerSuccess];
}

class BPartnerFailure extends WOServiceState {
  final String message;

  const BPartnerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class BPLocationSuccess extends WOServiceState {
  final List<BPLocationModel> bplocation;

  const BPLocationSuccess({required this.bplocation});

  @override
  List<Object> get props => [BPLocationSuccess];
}

class BPLocationFailure extends WOServiceState {
  final String message;

  const BPLocationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class DoctypeSuccess extends WOServiceState {
  final List<DoctypeWOModel> doctype;

  const DoctypeSuccess({required this.doctype});

  @override
  List<Object> get props => [DoctypeSuccess];
}

class DoctypeFailure extends WOServiceState {
  final String message;

  const DoctypeFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class EmployeeGroupSuccess extends WOServiceState {
  final List<EmployeeGroupModel> employeegroup;

  const EmployeeGroupSuccess({required this.employeegroup});

  @override
  List<Object> get props => [EmployeeGroupSuccess];
}

class EmployeeGroupFailure extends WOServiceState {
  final String message;

  const EmployeeGroupFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class EquipmentSuccess extends WOServiceState {
  final List<EquipmentModel> equipment;

  const EquipmentSuccess({required this.equipment});

  @override
  List<Object> get props => [EquipmentSuccess];
}

class EquipmentFailure extends WOServiceState {
  final String message;

  const EquipmentFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class SaveWOServiceSuccess extends WOServiceState {
  final int savewoservice;

  const SaveWOServiceSuccess({
    required this.savewoservice,
  });

  @override
  List<Object> get props => [savewoservice];
}

class SaveRecentItemsSuccess extends WOServiceState {
  final int recentitem;

  const SaveRecentItemsSuccess({
    required this.recentitem,
  });

  @override
  List<Object> get props => [recentitem];
}

class UpdateWOStatusSuccess extends WOServiceState {
  final bool updateWOstatus;

  const UpdateWOStatusSuccess({
    required this.updateWOstatus,
  });

  @override
  List<Object> get props => [updateWOstatus];
}

class TimeEntrySuccess extends WOServiceState {
  final List<TimeEntryModel> timeentry;

  const TimeEntrySuccess({required this.timeentry});

  @override
  List<Object> get props => [TimeEntrySuccess];
}

class TimeEntryFailure extends WOServiceState {
  final String message;

  const TimeEntryFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class UpdateTimeEntrySuccess extends WOServiceState {
  final bool updatetimeentry;

  const UpdateTimeEntrySuccess({
    required this.updatetimeentry,
  });

  @override
  List<Object> get props => [updatetimeentry];
}

class UpdateWOServiceSuccess extends WOServiceState {
  final bool updatewoservice;

  const UpdateWOServiceSuccess({
    required this.updatewoservice,
  });

  @override
  List<Object> get props => [updatewoservice];
}

class MeterTypeSuccess extends WOServiceState {
  final List<MeterTypeModel> metertype;

  const MeterTypeSuccess({required this.metertype});

  @override
  List<Object> get props => [MeterTypeSuccess];
}

class MeterTypeFailure extends WOServiceState {
  final String message;

  const MeterTypeFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CurrentDisplayMeterSuccess extends WOServiceState {
  final List<CurrentDisplayMeter> currentDisplayMeter;

  const CurrentDisplayMeterSuccess({required this.currentDisplayMeter});

  @override
  List<Object> get props => [MeterTypeSuccess];
}

class CurrentDisplayMeterFailure extends WOServiceState {
  final String message;

  const CurrentDisplayMeterFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class SaveMeterReadingSuccess extends WOServiceState {
  final bool meterreading;

  const SaveMeterReadingSuccess({
    required this.meterreading,
  });

  @override
  List<Object> get props => [meterreading];
}

class RecentItemsSuccess extends WOServiceState {
  final List<RecentItem> recentitem;

  const RecentItemsSuccess({required this.recentitem});

  @override
  List<Object> get props => [RecentItemsSuccess];
}

class RecentItemsFailure extends WOServiceState {
  final String message;

  const RecentItemsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class MeterReadingSuccess extends WOServiceState {
  final List<MeterReading> mreading;

  const MeterReadingSuccess({required this.mreading});

  @override
  List<Object> get props => [MeterReadingSuccess];
}

class MeterReadingFailure extends WOServiceState {
  final String message;

  const MeterReadingFailure({required this.message});

  @override
  List<Object> get props => [message];
}
