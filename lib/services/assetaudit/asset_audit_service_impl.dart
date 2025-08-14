import 'dart:convert';

import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditline.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetmodels.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../service_locator.dart';
import 'asset_audit_service.dart';

class AssetAuditServiceImpl implements AssetAuditService {
  final Dio dio;
  AssetAuditServiceImpl({required this.dio});
  final storage = sl<FlutterSecureStorage>();

  @override
  Future<List<AssetAuditHeader>> getAssetAuditHeader(String docno) async {
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    String query =
        "filter=AD_Client_ID=$clientId and docStatus ='DR' and documentNo = '$docno'";
    List<AssetAuditHeader> header = <AssetAuditHeader>[];
    try {
      final response = await dio.get("/models/BHP_AssetAudit?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetAuditHeader> list =
            data.map((i) => AssetAuditHeader.fromJson(i)).toList();
        header = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return header;
  }

  @override
  Future<List<AssetAuditLines>> getLinesAudited(int id) async {
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    String query =
        "filter=AD_Client_ID=$clientId and BHP_AssetAudit_ID = $id and isAudited ='Y' ";
    List<AssetAuditLines> lines = <AssetAuditLines>[];
    try {
      final response = await dio.get("/models/bhp_mv_assetauditline?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        lines = data.map((i) => AssetAuditLines.fromJson(i)).toList();
        lines.sort((a, b) => b.updated.compareTo(a.updated));
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return lines;
  }

  @override
  Future<List<AssetAuditLines>> getAssetAuditLines(
      int idHeader, var asset) async {
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    String query =
        "filter=AD_Client_ID=$clientId and BHP_AssetAudit_ID = $idHeader and assetvalue = '$asset'";
    List<AssetAuditLines> lines = <AssetAuditLines>[];
    try {
      final response = await dio.get("/models/bhp_mv_assetauditline?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        return [];
      } else {
        List<AssetAuditLines> list =
            data.map((i) => AssetAuditLines.fromJson(i)).toList();
        lines = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return lines;
  }

  @override
  Future<List<AssetModel>> isAssetAvailable(var assetSearchKey) async {
    List<AssetModel> asset = <AssetModel>[];
    try {
      final clientId = await storage.read(key: AuthKey.clientId.toString());
      final checkAsset = await dio.get(
          "/models/A_Asset?filter= AD_Client_ID=$clientId and value = '$assetSearchKey'");
      var data = (checkAsset.data as List);
      if (data.isNotEmpty) {
        asset = data.map((i) => AssetModel.fromJson(i)).toList();
      } else {
        // throw DioError(error: 'Asset not available');
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return asset;
  }

  @override
  Future<List<AssetAuditStatusModel>> getAssetAuditStatus() async {
    List<AssetAuditStatusModel> assetStatus = <AssetAuditStatusModel>[];
    try {
      final response = await dio.get("/models/bhp_mv_assetstatuslist");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetAuditStatusModel> list =
            data.map((i) => AssetAuditStatusModel.fromJson(i)).toList();
        assetStatus = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return assetStatus;
  }

  @override
  Future<bool> deleteLine(AssetAuditLines line) async {
    bool success;
    try {
      final response = await dio
          .delete("/windows/asset-audit/tabs/asset-audit-line/${line.id}/");
      success = response.statusCode == 200;
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return Future.value(success);
  }

  @override
  Future<bool> mergeLine(AssetAuditPut line, int lineID) async {
    bool? success;
    final jsonMap = jsonEncode((line).toJson());
    print(jsonMap);
    try {
      final response = await dio.put(
        "/windows/asset-audit/tabs/asset-audit-line/$lineID/",
        data: jsonMap,
      );
      if (response.statusCode == 200) {
        success = true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return success!;
  }

  @override
  Future<bool> createNew(AssetAuditPut line, int headerID) async {
    bool success = false;
    final jsonMap = jsonEncode((line).toJson());
    print(jsonMap);
    try {
      final response = await dio.post(
        "/models/BHP_AssetAuditLine?filter=BHP_AssetAudit_ID=$headerID",
        data: jsonMap,
      );
      if (response.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return success;
  }
}
