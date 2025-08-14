import 'package:apps_mobile/business_logic/models/assetrcvmodel/assetrcvdata_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrf.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';

abstract class AssetTransferService {
  Future<List<AssetRequestLine>> getAssetTransferLine(var docno);
  Future<List<AssetRequestModel>> getAssetRequest();
  Future<List<AssetRequestLine>> getAssetTransferLinebySerno(
      String serno, int id);
  Future<List<AssetRcvData>> getAssetRcvData(var serno);
  Future<List<Reference>> getAssetTrackingLocation(var locID);
  Future<GenerateData> pushData(GenerateData data, String tablename);
  Future<List<AssetRcvData>> getAssetDataRcvLocation(int locID);
  Future<List<AssetRcvData>> getAssetDataRcvLines(int locID, String serno);
}
