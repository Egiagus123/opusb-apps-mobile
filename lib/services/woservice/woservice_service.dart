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

abstract class WOServiceService {
  Future<List<WOServiceModel>> getWOService();
  Future<List<WOServiceModel>> getWOService_(int pageNo);
  Future<List<WOServiceModel>> getWOServiceRequest();
  Future<List<WOServiceModel>> getWOServiceRequest_(int pageNo);
  Future<List<WOStatusModel>> getWOStatus();
  Future<List<PriorityModel>> getPriority();
  Future<List<BusinessPartnerModel>> getBPartner();
  Future<List<BPLocationModel>> getBPLocation(int bpid);
  Future<List<DoctypeWOModel>> getDoctype();
  Future<List<EmployeeGroupModel>> getEmployeeGroup();
  Future<List<EquipmentModel>> getEquipment();
  Future<List<MeterTypeModel>> getMetertype();
  Future<int> saveWOservice(dynamic data);
  Future<bool> updateWOStatus(dynamic data);
  Future<List<TimeEntryModel>> getTimeEntry(int woserviceid);
  Future<bool> editTimeEntry(dynamic data, int timeentryid);
  Future<bool> editWORequest(dynamic data, int timeentryid);
  Future<List<CurrentDisplayMeter>> getCurrentDisplayMeter();
  Future<bool> saveMeterReading(dynamic data);
  Future<List<WOServiceModel>> getWOServiceRequestID(int woserviceid);
  Future<int> saverecentitem(dynamic data);
  Future<List<RecentItem>> getRecentItem();
  Future<List<MeterReading>> getMeterReading();
}
