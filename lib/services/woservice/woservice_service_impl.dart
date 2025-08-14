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
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../service_locator.dart';
import 'woservice_service.dart';

class WOServiceImpl implements WOServiceService {
  final Dio dio;
  WOServiceImpl({required this.dio});
  final storage = sl<FlutterSecureStorage>();

  @override
  Future<List<WOServiceModel>> getWOService() async {
    List<WOServiceModel> wos = <WOServiceModel>[];
    print("?filter=wostatus NOT IN ('DR')");
    try {
      final response = await dio.get("/windows/wo-service-api");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<WOServiceModel> list =
            data.map((i) => WOServiceModel.fromJson(i)).toList();
        wos = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return wos;
  }

  @override
  Future<List<WOServiceModel>> getWOService_(int pageNo) async {
    List<WOServiceModel> wos = <WOServiceModel>[];
    print("?filter=wostatus NOT IN ('DR')");
    try {
      final response = await dio.get(
          "/windows/wo-service-api?filter=wOStatus NOT IN ('DR')&pageNo=$pageNo");
      var data = (response.data as List);

      print("datanya adalah $data");
      if (data.isEmpty) {
        // do nothing
      } else {
        List<WOServiceModel> list =
            data.map((i) => WOServiceModel.fromJson(i)).toList();
        wos = list.reversed.toList();
      }
    } on DioError catch (e) {
      wos = [];
    }

    return wos;
  }

  @override
  Future<List<WOServiceModel>> getWOServiceRequest() async {
    List<WOServiceModel> wos = <WOServiceModel>[];
    try {
      final response = await dio.get("/windows/wo-service-api");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<WOServiceModel> list =
            data.map((i) => WOServiceModel.fromJson(i)).toList();
        wos = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return wos;
  }

  @override
  Future<List<WOServiceModel>> getWOServiceRequest_(int pageNo) async {
    List<WOServiceModel> wos = <WOServiceModel>[];
    try {
      final response = await dio.get(
          "/windows/wo-service-api?filter=wOStatus IN ('DR')&pageNo=$pageNo");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<WOServiceModel> list =
            data.map((i) => WOServiceModel.fromJson(i)).toList();
        wos = list.reversed.toList();
      }
    } on DioError catch (e) {
      wos = [];
    }

    return wos;
  }

  @override
  Future<List<WOStatusModel>> getWOStatus() async {
    List<WOStatusModel> wosstatus = <WOStatusModel>[];
    try {
      final response = await dio.get(
          "/models/ad_ref_list?filter=AD_Reference_ID IN (SELECT AD_Reference_ID FROM AD_Reference WHERE Name = 'WO_Status')");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<WOStatusModel> list =
            data.map((i) => WOStatusModel.fromJson(i)).toList();
        wosstatus = list.reversed.toList();

        print("data wostatus adalah $wosstatus");
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return wosstatus;
  }

  @override
  Future<List<PriorityModel>> getPriority() async {
    List<PriorityModel> priority = <PriorityModel>[];
    try {
      final response = await dio.get(
          "/models/ad_ref_list?filter=AD_Reference_ID IN (SELECT AD_Reference_ID FROM AD_Reference WHERE Name = '_PriorityRule')");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<PriorityModel> list =
            data.map((i) => PriorityModel.fromJson(i)).toList();
        priority = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return priority;
  }

  @override
  Future<List<BusinessPartnerModel>> getBPartner() async {
    List<BusinessPartnerModel> bp = <BusinessPartnerModel>[];
    try {
      final response =
          await dio.get("/models/c_bpartner?filter=IsCustomer='Y'");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<BusinessPartnerModel> list =
            data.map((i) => BusinessPartnerModel.fromJson(i)).toList();
        bp = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return bp;
  }

  @override
  Future<List<BPLocationModel>> getBPLocation(int bpid) async {
    List<BPLocationModel> bplocation = <BPLocationModel>[];
    try {
      final response = await dio
          .get("/models/c_bpartner_location?filter=C_BPartner_ID=$bpid");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<BPLocationModel> list =
            data.map((i) => BPLocationModel.fromJson(i)).toList();
        bplocation = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return bplocation;
  }

  @override
  Future<List<DoctypeWOModel>> getDoctype() async {
    List<DoctypeWOModel> doctype = <DoctypeWOModel>[];
    try {
      final response =
          await dio.get("/models/c_doctype?filter=docbasetype ='WOS'");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<DoctypeWOModel> list =
            data.map((i) => DoctypeWOModel.fromJson(i)).toList();
        doctype = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return doctype;
  }

  @override
  Future<List<EmployeeGroupModel>> getEmployeeGroup() async {
    List<EmployeeGroupModel> employee = <EmployeeGroupModel>[];
    try {
      final response = await dio.get("/models/bhp_employeegroup");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<EmployeeGroupModel> list =
            data.map((i) => EmployeeGroupModel.fromJson(i)).toList();
        employee = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return employee;
  }

  @override
  Future<List<EquipmentModel>> getEquipment() async {
    List<EquipmentModel> equipment = <EquipmentModel>[];
    try {
      final response =
          await dio.get("/models/bhp_m_installbase?filter=isactive='Y'");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<EquipmentModel> list =
            data.map((i) => EquipmentModel.fromJson(i)).toList();
        equipment = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return equipment;
  }

  @override
  Future<List<CurrentDisplayMeter>> getCurrentDisplayMeter() async {
    List<CurrentDisplayMeter> currentdisplaymeter = <CurrentDisplayMeter>[];
    try {
      final response = await dio.get("/windows/current-display-meter-api");
      var data = (response.data as List);

      print("data aja $data");
      if (data.isEmpty) {
        // do nothing
      } else {
        currentdisplaymeter =
            data.map((i) => CurrentDisplayMeter.fromJson(i)).toList();
        print("data aja 2 $currentdisplaymeter");
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return currentdisplaymeter;
  }

  @override
  Future<int> saveWOservice(dynamic data) async {
    int id;

    try {
      final response =
          await dio.post("/processes/create-woservice", data: data);
      if (response.statusCode == 200) {
        return id = response.data["id"];
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return id = 0;
  }

  @override
  Future<bool> updateWOStatus(dynamic data) async {
    bool isSuccess;

    try {
      final response = await dio.post("/processes/update-status", data: data);
      if (response.statusCode == 200) {
        return isSuccess = true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return isSuccess = false;
  }

  @override
  Future<List<TimeEntryModel>> getTimeEntry(int woserviceid) async {
    List<TimeEntryModel> timeentry = <TimeEntryModel>[];
    try {
      final response = await dio
          .get("/windows/time-entry-api?filter=BHP_WOService_ID=$woserviceid");
      var data = (response.data as List);
      print(data);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<TimeEntryModel> list =
            data.map((i) => TimeEntryModel.fromJson(i)).toList();
        timeentry = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return timeentry;
  }

  @override
  Future<bool> editTimeEntry(dynamic data, int timeentryid) async {
    bool isSuccess;

    try {
      final response = await dio
          .put("/models/BHP_ResourceAssignment/$timeentryid", data: data);
      if (response.statusCode == 200) {
        return isSuccess = true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return isSuccess = false;
  }

  @override
  Future<List<MeterTypeModel>> getMetertype() async {
    List<MeterTypeModel> metertype = <MeterTypeModel>[];
    try {
      final response = await dio.get(
          "/models/BHP_M_MeterDisplay?filter=AD_Org_ID=${Context().orgId}");
      var data = (response.data as List);
      print("coba aja ${Context().orgId}");
      if (data.isEmpty) {
        // do nothing
      } else {
        List<MeterTypeModel> list =
            data.map((i) => MeterTypeModel.fromJson(i)).toList();
        metertype = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return metertype;
  }

  @override
  Future<bool> editWORequest(dynamic data, int woserviceid) async {
    bool isSuccess;

    try {
      final response =
          await dio.put("/models/bhp_woservice/$woserviceid", data: data);
      if (response.statusCode == 200) {
        return isSuccess = true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return isSuccess = false;
  }

  @override
  Future<bool> saveMeterReading(dynamic data) async {
    bool isSuccess;

    try {
      final response = await dio.post("/models/BHP_MeterReading", data: data);
      if (response.statusCode == 200) {
        print(response);
        return isSuccess = true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return isSuccess = false;
  }

  @override
  Future<List<WOServiceModel>> getWOServiceRequestID(int woserviceid) async {
    List<WOServiceModel> wos = <WOServiceModel>[];
    try {
      final response = await dio
          .get("/windows/wo-service-api?filter=BHP_WOService_ID=$woserviceid");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<WOServiceModel> list =
            data.map((i) => WOServiceModel.fromJson(i)).toList();
        wos = list.reversed.toList();
      }
    } on DioError catch (e) {
      wos = [];
    }

    return wos;
  }

  @override
  Future<int> saverecentitem(dynamic data) async {
    int id;

    try {
      final response = await dio.post("/windows/bhp-recent-items", data: data);
      if (response.statusCode == 200) {
        print("idnya adalah ${response.data["id"]}");
        return id = response.data["id"];
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return id = 0;
  }

  @override
  Future<List<RecentItem>> getRecentItem() async {
    List<RecentItem> recentitem = <RecentItem>[];
    try {
      int idhh = Context().userId;
      print("userntya $idhh");
      final response = await dio.get(
          "/windows/bhp-recent-items?filter=CreatedBy=${Context().userId}");
      var data = (response.data as List);
      print("Recent Item adalah ${data}");
      if (data.isEmpty) {
        // do nothing
      } else {
        List<RecentItem> list =
            data.map((i) => RecentItem.fromJson(i)).toList();
        recentitem = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return recentitem;
  }

  @override
  Future<List<MeterReading>> getMeterReading() async {
    List<MeterReading> meterreading = <MeterReading>[];
    try {
      final response = await dio.get("/windows/meter-reading");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<MeterReading> list =
            data.map((i) => MeterReading.fromJson(i)).toList();
        meterreading = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return meterreading;
  }
}
