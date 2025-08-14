import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditline.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetmodels.dart';

abstract class AssetAuditService {
  Future<List<AssetAuditHeader>> getAssetAuditHeader(String docno);
  Future<List<AssetAuditLines>> getLinesAudited(int id);
  Future<List<AssetAuditLines>> getAssetAuditLines(int idHeader, var asset);
  Future<List<AssetModel>> isAssetAvailable(var assetSearchKey);
  Future<List<AssetAuditStatusModel>> getAssetAuditStatus();
  Future<bool> deleteLine(AssetAuditLines line);
  Future<bool> mergeLine(AssetAuditPut line, int lineID);
  Future<bool> createNew(AssetAuditPut line, int headerID);
}
