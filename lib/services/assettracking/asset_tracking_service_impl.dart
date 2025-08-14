// import 'dart:convert';

import 'package:apps_mobile/business_logic/models/assettrackingloc_model.dart';
import 'package:apps_mobile/business_logic/models/assettrackingstatus_model.dart';
import 'package:apps_mobile/business_logic/models/image_equipment.dart';
import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/business_logic/models/installbasestatus.dart';
import 'package:apps_mobile/business_logic/models/installbasetrf.dart';
import 'package:apps_mobile/business_logic/models/pm_list.dart';
import 'package:apps_mobile/business_logic/models/pmbacklog.dart';
import 'package:apps_mobile/business_logic/models/user_data.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../service_locator.dart';
import 'asset_tracking_service.dart';

class AssetTrackingServiceImpl implements AssetTrackingService {
  final Dio dio;
  AssetTrackingServiceImpl({required this.dio});
  final storage = sl<FlutterSecureStorage>();
  @override
  Future<List<AssetTrackingLocation>> getAssetTrackingLocation() async {
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    String query = "filter=AD_Client_ID=$clientId and IsAssetLocator ='Y'";
    List<AssetTrackingLocation> loc = <AssetTrackingLocation>[];
    try {
      final response = await dio.get("/models/M_Locator?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetTrackingLocation> list =
            data.map((i) => AssetTrackingLocation.fromJson(i)).toList();
        loc = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return loc;
  }

  @override
  Future<List<AssetTrackingStatus>> getAssetTrackingStatus() async {
    List<AssetTrackingStatus> status = <AssetTrackingStatus>[];
    try {
      final response = await dio.get("/windows/bhp_rv_assettracking_status");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetTrackingStatus> list =
            data.map((i) => AssetTrackingStatus.fromJson(i)).toList();
        status = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return status;
  }

  @override
  Future<List<InstallBaseModel>> getListDataAsset(
      String sn, status, location) async {
    List<InstallBaseModel> installbase = <InstallBaseModel>[];
    final clientId = await storage.read(key: AuthKey.clientId.toString());

    print("coba masuk");
    String query = "filter=AD_Client_ID=$clientId";
    if (!sn.contains("")) {
      query += ' and serno= \'$sn\'';
    }
    if (!status.contains("")) {
      query += ' and status= \'$status\'';
    }
    if (!location.contains("")) {
      query += ' and M_Locator_ID= $location';
    }

    try {
      final response = await dio.get("/models/BHP_M_InstallBase?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<InstallBaseModel> list =
            data.map((i) => InstallBaseModel.fromJson(i)).toList();
        installbase = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return installbase;
  }

  @override
  Future<String> getphoto(int assetID) async {
    try {
      final response = await dio.get(
          "/models/AD_Image?filter=isactive='Y' and AD_Image_ID = (select Logo_ID From BHP_M_InstallBase where BHP_M_InstallBase_ID=$assetID)");
      var foto = (response.data as List);
      if (response.data.isNotEmpty) {
        UserData data = UserData.fromJson(foto.first);
        return data.binaryData;
      }
      return 'null';
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }

  @override
  Future<List<InstallBaseStatus>> getInstallBaseStatusHistory(
      int assetID) async {
    List<InstallBaseStatus> statusHistory = <InstallBaseStatus>[];
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    try {
      final response = await dio.get(
          "/models/BHP_M_InstallBaseStatus?filter=BHP_M_InstallBase_ID=$assetID and ad_client_id=$clientId");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<InstallBaseStatus> list =
            data.map((i) => InstallBaseStatus.fromJson(i)).toList();
        statusHistory = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return statusHistory;
  }

  @override
  Future<List<InstallBaseTransfer>> getInstallBaseTransferHistory(
      int assetID) async {
    List<InstallBaseTransfer> trfhistory = <InstallBaseTransfer>[];
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    try {
      final response = await dio.get(
          "/models/BHP_ToolTransferHistory?filter=BHP_M_InstallBase_ID=$assetID and ad_client_id=$clientId");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<InstallBaseTransfer> list =
            data.map((i) => InstallBaseTransfer.fromJson(i)).toList();
        trfhistory = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return trfhistory;
  }

  @override
  Future<List<PMBacklogModel>> getPMBaclock(int equipmentid) async {
    List<PMBacklogModel> pmbacklock = <PMBacklogModel>[];
    try {
      final response = await dio.get(
          "/windows/pmbacklog-api?filter=BHP_M_InstallBase_ID=$equipmentid");
      var data = (response.data as List);
      print("datapmbacklog dalah $data");
      if (data.isEmpty) {
        // do nothing
      } else {
        List<PMBacklogModel> list =
            data.map((i) => PMBacklogModel.fromJson(i)).toList();
        pmbacklock = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return pmbacklock;
  }

  @override
  Future<List<ImageEquipment>> getImageEquipment(int equipmentid) async {
    List<ImageEquipment> imageEquipment = <ImageEquipment>[];
    try {
      final response = await dio.get(
          "/models/AD_Image?filter=isactive='Y' and AD_Image_ID = (select Logo_ID From BHP_M_InstallBase where BHP_M_InstallBase_ID=$equipmentid)");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<ImageEquipment> list =
            data.map((i) => ImageEquipment.fromJson(i)).toList();
        imageEquipment = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return imageEquipment;
  }

  @override
  Future<List<PMSListModel>> getPMListDue() async {
    List<PMSListModel> pmScheduledata = <PMSListModel>[];
    try {
      final response = await dio.get("/models/BHP_PM?filter=PM_Status='DU'");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<PMSListModel> list =
            data.map((i) => PMSListModel.fromJson(i)).toList();
        pmScheduledata = list.reversed.toList();
        print(pmScheduledata);
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return pmScheduledata;
  }

  @override
  Future<List<PMSListModel>> getPMListShedule() async {
    List<PMSListModel> pmScheduledata = <PMSListModel>[];
    try {
      final response = await dio.get("/models/BHP_PM?filter=PM_Status='SH'");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<PMSListModel> list =
            data.map((i) => PMSListModel.fromJson(i)).toList();
        pmScheduledata = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return pmScheduledata;
  }
}
