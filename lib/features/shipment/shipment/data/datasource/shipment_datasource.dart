import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_model.dart';

abstract class ShipmentDataSource {
  Future<int> getDocTypeId(int poDocTypeId);
  Future<ShipmentModel> push(Map<String, dynamic> data);
}
