import 'package:apps_mobile/business_logic/models/assetrcvmodel/assetrcvdata_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrf.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../service_locator.dart';
import 'asset_trf_service.dart';
import 'dart:convert';

class AssetTransferServiceImpl implements AssetTransferService {
  final Dio dio;
  AssetTransferServiceImpl({required this.dio});
  final storage = sl<FlutterSecureStorage>();
  @override
  Future<List<AssetRequestModel>> getAssetRequest() async {
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    String query = "filter=AD_Client_ID=$clientId";
    List<AssetRequestModel> assetRequestModel = <AssetRequestModel>[];
    try {
      final response =
          await dio.get("/windows/bhp_mv_eam_movementrequest?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetRequestModel> list =
            data.map((i) => AssetRequestModel.fromJson(i)).toList();
        assetRequestModel = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return assetRequestModel;
  }

  @override
  Future<List<AssetRequestLine>> getAssetTransferLine(var id) async {
    List<AssetRequestLine> status = <AssetRequestLine>[];
    String query =
        "filter= BHP_ToolRequest_ID =$id and QtyDelivered < QtyEntered  ";
    try {
      final response = await dio.get("/models/BHP_ToolRequestLine?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetRequestLine> list =
            data.map((i) => AssetRequestLine.fromJson(i)).toList();
        status = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return status;
  }

  // @override
  // Future<List<InstallBaseModel>> getSerno(var serno, int id) async {
  //   List<InstallBaseModel> installbase = <InstallBaseModel>[];
  //   final clientId = await storage.read(key: AuthKey.clientId.toString());

  //   String query =
  //       "filter=AD_Client_ID=$clientId and serNo= '$serno' and A_Asset_ID=$assetID ";

  //   try {
  //     final response = await dio.get("/models/BHP_M_InstallBase?$query");
  //     var data = (response.data as List);
  //     if (data.isEmpty) {
  //       // do nothing
  //     } else {
  //       List<InstallBaseModel> list =
  //           data.map((i) => InstallBaseModel.fromJson(i)).toList();
  //       installbase = list.reversed.toList();
  //     }
  //   } on DioError catch (e) {
  //     throw e.error;
  //   }

  //   return installbase;
  // }

  @override
  Future<List<AssetRequestLine>> getAssetTransferLinebySerno(
      String serNo, int id) async {
    List<AssetRequestLine> line = <AssetRequestLine>[];
    String query =
        "filter= BHP_ToolRequest_ID =$id and QtyDelivered < QtyEntered and serno='$serNo' ";
    try {
      final response = await dio.get("/models/BHP_ToolRequestLine?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetRequestLine> list =
            data.map((i) => AssetRequestLine.fromJson(i)).toList();
        line = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return line;
  }

  @override
  Future<List<AssetRcvData>> getAssetRcvData(var serno) async {
    List<AssetRcvData> assetRcvData = <AssetRcvData>[];
    final clientId = await storage.read(key: AuthKey.clientId.toString());

    String query = "filter=AD_Client_ID=$clientId and serNo= '$serno'";

    try {
      final response = await dio.get("/models/bhp_mv_eam_receivingdata?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetRcvData> list =
            data.map((i) => AssetRcvData.fromJson(i)).toList();
        assetRcvData = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return assetRcvData;
  }

  @override
  Future<List<Reference>> getAssetTrackingLocation(var locID) async {
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    String query =
        "filter=AD_Client_ID=$clientId and IsAssetLocator ='Y' and m_locator_new_id = $locID";
    List<Reference> loc = <Reference>[];
    try {
      final response = await dio.get("/models/M_Locator?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<Reference> list = data.map((i) => Reference.fromJson(i)).toList();
        loc = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return loc;
  }

  @override
  Future<GenerateData> pushData(GenerateData data, String tablename) async {
    try {
      final jsonMap = jsonEncode((data).toJson());

      print(jsonMap);

      final response = await dio.post('/windows/$tablename', data: jsonMap);
      return GenerateData.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }

  @override
  Future<List<AssetRcvData>> getAssetDataRcvLocation(int locID) async {
    List<AssetRcvData> assetRcvData = <AssetRcvData>[];
    final clientId = await storage.read(key: AuthKey.clientId.toString());

    String query =
        "filter=AD_Client_ID=$clientId and m_locator_new_id = $locID";

    try {
      final response = await dio.get("/models/bhp_mv_eam_receivingdata?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetRcvData> list =
            data.map((i) => AssetRcvData.fromJson(i)).toList();
        assetRcvData = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return assetRcvData;
  }

  Future<List<AssetRcvData>> getAssetDataRcvLines(
      int locID, String serno) async {
    List<AssetRcvData> assetRcvData = <AssetRcvData>[];
    final clientId = await storage.read(key: AuthKey.clientId.toString());

    String query =
        "filter=AD_Client_ID=$clientId and m_locator_new_id = $locID and serNo= '$serno'";

    try {
      final response = await dio.get("/models/bhp_mv_eam_receivingdata?$query");
      var data = (response.data as List);
      if (data.isEmpty) {
        // do nothing
      } else {
        List<AssetRcvData> list =
            data.map((i) => AssetRcvData.fromJson(i)).toList();
        assetRcvData = list.reversed.toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }

    return assetRcvData;
  }
}
