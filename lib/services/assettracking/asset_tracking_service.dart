import 'package:apps_mobile/business_logic/models/assettrackingloc_model.dart';
import 'package:apps_mobile/business_logic/models/assettrackingstatus_model.dart';
import 'package:apps_mobile/business_logic/models/image_equipment.dart';
import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/business_logic/models/installbasestatus.dart';
import 'package:apps_mobile/business_logic/models/installbasetrf.dart';
import 'package:apps_mobile/business_logic/models/pm_list.dart';
import 'package:apps_mobile/business_logic/models/pmbacklog.dart';

abstract class AssetTrackingService {
  Future<List<AssetTrackingLocation>> getAssetTrackingLocation();
  Future<List<AssetTrackingStatus>> getAssetTrackingStatus();
  Future<List<InstallBaseModel>> getListDataAsset(String sn, status, location);
  Future<String> getphoto(int assetID);
  Future<List<InstallBaseStatus>> getInstallBaseStatusHistory(int assetID);
  Future<List<InstallBaseTransfer>> getInstallBaseTransferHistory(int assetID);
  Future<List<PMBacklogModel>> getPMBaclock(int equipmentid);
  Future<List<ImageEquipment>> getImageEquipment(int equipmentid);
  Future<List<PMSListModel>> getPMListDue();
  Future<List<PMSListModel>> getPMListShedule();
}
