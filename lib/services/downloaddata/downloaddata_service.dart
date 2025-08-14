import 'package:apps_mobile/business_logic/models/assetrcvmodel/assetrcvdata_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';

abstract class DownloadDataService {
  Future<List<AssetRequestLine>> getAssetTransferLine(var docno);
  Future<List<AssetRequestModel>> getAssetRequest();
  Future<List<AssetRequestLine>> getAssetTransferLinebySerno(
      String serno, int id);
  Future<List<AssetRcvData>> getAssetRcvData();
}
