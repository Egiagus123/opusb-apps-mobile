import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/tooltrf_header.dart';

abstract class OfflineService {
  Future<ToolsTrfHeader> pushTrxAsset(ToolsTrfHeader data);
  Future<bool> insertShipment(ShipmentOfflineModel data);
}
