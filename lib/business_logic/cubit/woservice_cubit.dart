import 'dart:convert';

import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/currentdisplaymeter.dart';
import 'package:apps_mobile/business_logic/models/doctypewo.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/meterdisplay.dart';
import 'package:apps_mobile/business_logic/models/meterreading.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/recentitem.dart';
import 'package:apps_mobile/business_logic/models/timeentry.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/woservice/woservice_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'woservice_state.dart';

class WOServiceCubit extends Cubit<WOServiceState> {
  final log = getLogger('WOServiceCubit');
  WOServiceCubit() : super(WOServiceInitial());

  Future<void> getWOService() async {
    log.i('WOService');
    try {
      emit(WOServiceLoadInProgress());
      List<WOServiceModel> listservice =
          await sl<WOServiceService>().getWOService();
      emit(WOServiceSuccess(listservice: listservice));
    } catch (e) {
      log.e('getpwoserviceerror: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getWOServiceID() async {
    log.i('WOService');
    try {
      emit(WOServiceLoadInProgress());
      List<WOServiceModel> listservice =
          await sl<WOServiceService>().getWOServiceRequest();
      emit(WOServiceSuccess(listservice: listservice));
    } catch (e) {
      log.e('getpwoserviceerror: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getMeterReading() async {
    log.i('getMeterReading');
    try {
      emit(WOServiceLoadInProgress());
      List<MeterReading> meterreading =
          await sl<WOServiceService>().getMeterReading();
      emit(MeterReadingSuccess(mreading: meterreading));
    } catch (e) {
      log.e('getMeterReadingerror: $e');
      emit(MeterReadingFailure(message: e.toString()));
    }
  }

  Future<void> getWOServiceRequest() async {
    log.i('WOService');
    try {
      emit(WOServiceLoadInProgress());
      List<WOServiceModel> listservice =
          await sl<WOServiceService>().getWOServiceRequest();
      emit(WOServiceSuccess(listservice: listservice));
    } catch (e) {
      log.e('getpwoserviceerror: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getWOStatus() async {
    log.i('WOStatus');
    try {
      emit(WOServiceLoadInProgress());
      List<WOStatusModel> wostatus = await sl<WOServiceService>().getWOStatus();
      emit(WOStatusSuccess(wostatus: wostatus));
    } catch (e) {
      log.e('getWOStatuserror: $e');
      emit(WOStatusFailure(message: e.toString()));
    }
  }

  Future<void> getPriority() async {
    log.i('Priority');
    try {
      emit(WOServiceLoadInProgress());
      List<PriorityModel> priority = await sl<WOServiceService>().getPriority();
      emit(PrioritySuccess(priority: priority));
    } catch (e) {
      log.e('getPriorityerror: $e');
      emit(PriorityFailure(message: e.toString()));
    }
  }

  Future<void> getBPpartner() async {
    log.i('BPpartner');
    try {
      emit(WOServiceLoadInProgress());
      List<BusinessPartnerModel> bpartner =
          await sl<WOServiceService>().getBPartner();
      emit(BPartnerSuccess(bpartner: bpartner));
    } catch (e) {
      log.e('getBPpartnererror: $e');
      emit(BPartnerFailure(message: e.toString()));
    }
  }

  Future<void> getBPLocation(int bpid) async {
    log.i('BPLocation');
    try {
      emit(WOServiceLoadInProgress());
      List<BPLocationModel> bplocation =
          await sl<WOServiceService>().getBPLocation(bpid);
      emit(BPLocationSuccess(bplocation: bplocation));
    } catch (e) {
      log.e('getBPLocationerror: $e');
      emit(BPLocationFailure(message: e.toString()));
    }
  }

  Future<void> getDoctype() async {
    log.i('getDoctype');
    try {
      emit(WOServiceLoadInProgress());
      List<DoctypeWOModel> doctype = await sl<WOServiceService>().getDoctype();
      emit(DoctypeSuccess(doctype: doctype));
    } catch (e) {
      log.e('getDoctypeerror: $e');
      emit(DoctypeFailure(message: e.toString()));
    }
  }

  Future<void> getEmployeeGroup() async {
    log.i('getEmployeeGroup');
    try {
      emit(WOServiceLoadInProgress());
      List<EmployeeGroupModel> employeegroup =
          await sl<WOServiceService>().getEmployeeGroup();
      emit(EmployeeGroupSuccess(employeegroup: employeegroup));
    } catch (e) {
      log.e('getEmployeeGrouperror: $e');
      emit(EmployeeGroupFailure(message: e.toString()));
    }
  }

  Future<void> getEquipment() async {
    log.i('getEquipment');
    try {
      emit(WOServiceLoadInProgress());
      List<EquipmentModel> equipment =
          await sl<WOServiceService>().getEquipment();
      emit(EquipmentSuccess(equipment: equipment));
    } catch (e) {
      log.e('getEquipment $e');
      emit(EquipmentFailure(message: e.toString()));
    }
  }

  Future<void> savewoservice(dynamic data) async {
    log.i('savewoservice');

    try {
      emit(WOServiceLoadInProgress());
      data = jsonEncode(data);
      print(data);
      int isSuccess = await sl<WOServiceService>().saveWOservice(data);
      emit(SaveWOServiceSuccess(savewoservice: isSuccess));
    } catch (e) {
      log.e('savewoservice error: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> saverecentitems(dynamic data) async {
    log.i('saverecentitems');

    try {
      emit(WOServiceLoadInProgress());
      data = jsonEncode(data);
      print(data);
      int id = await sl<WOServiceService>().saverecentitem(data);
      emit(SaveRecentItemsSuccess(recentitem: id));
    } catch (e) {
      log.e('saverecentitems error: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> updatewostatus(dynamic data) async {
    log.i('updatewostatus');

    try {
      emit(WOServiceLoadInProgress());
      data = jsonEncode(data);
      print(data);
      bool isSuccess = await sl<WOServiceService>().updateWOStatus(data);
      emit(UpdateWOStatusSuccess(updateWOstatus: isSuccess));
    } catch (e) {
      log.e('updatewostatus error: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getTimeEntry(int woserviceid) async {
    log.i('getTimeEntry');
    try {
      emit(WOServiceLoadInProgress());
      List<TimeEntryModel> timeentry =
          await sl<WOServiceService>().getTimeEntry(woserviceid);
      emit(TimeEntrySuccess(timeentry: timeentry));
    } catch (e) {
      log.e('getTimeEntry $e');
      emit(TimeEntryFailure(message: e.toString()));
    }
  }

  Future<void> editTimeEntry(dynamic data, int timeentry) async {
    log.i('editTimeEntry');

    try {
      emit(WOServiceLoadInProgress());
      data = jsonEncode(data);
      print(data);
      bool isSuccess =
          await sl<WOServiceService>().editTimeEntry(data, timeentry);
      emit(UpdateTimeEntrySuccess(updatetimeentry: isSuccess));
    } catch (e) {
      log.e('editTimeEntry error: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getMeterType() async {
    log.i('getMeterType');
    try {
      emit(WOServiceLoadInProgress());
      List<MeterTypeModel> metertype =
          await sl<WOServiceService>().getMetertype();
      emit(MeterTypeSuccess(metertype: metertype));
    } catch (e) {
      log.e('getMeterType error: $e');
      emit(DoctypeFailure(message: e.toString()));
    }
  }

  Future<void> editWORequest(dynamic data, int woserviceid) async {
    log.i('editWORequest');

    try {
      emit(WOServiceLoadInProgress());
      data = jsonEncode(data);
      print(data);
      bool isSuccess =
          await sl<WOServiceService>().editWORequest(data, woserviceid);
      emit(UpdateWOServiceSuccess(updatewoservice: isSuccess));
    } catch (e) {
      log.e('editWORequest error: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getCurrentDisplayMeter() async {
    log.i('getCurrentDisplayMeter');
    try {
      emit(WOServiceLoadInProgress());
      List<CurrentDisplayMeter> currentDisplayMeter =
          await sl<WOServiceService>().getCurrentDisplayMeter();
      emit(
          CurrentDisplayMeterSuccess(currentDisplayMeter: currentDisplayMeter));
    } catch (e) {
      log.e('getCurrentDisplayMeter error: $e');
      emit(CurrentDisplayMeterFailure(message: e.toString()));
    }
  }

  Future<void> saveMeterReading(dynamic data) async {
    log.i('saveMeterReading');

    try {
      emit(WOServiceLoadInProgress());
      data = jsonEncode(data);
      print(data);
      bool isSuccess = await sl<WOServiceService>().saveMeterReading(data);
      emit(SaveMeterReadingSuccess(meterreading: isSuccess));
    } catch (e) {
      log.e('saveMeterReading error: $e');
      emit(WOServiceFailure(message: e.toString()));
    }
  }

  Future<void> getRecentItem() async {
    log.i('getRecentItem');
    try {
      emit(WOServiceLoadInProgress());
      List<RecentItem> recentitem =
          await sl<WOServiceService>().getRecentItem();
      emit(RecentItemsSuccess(recentitem: recentitem));
    } catch (e) {
      log.e('getRecentItem $e');
      emit(RecentItemsFailure(message: e.toString()));
    }
  }
}
