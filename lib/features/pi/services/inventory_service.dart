import 'package:apps_mobile/business_logic/models/reference.dart';

import '../models/locator.dart';
import '../models/physical_inventory.dart';
import '../models/physical_inventory_line.dart';
import '../models/product.dart';

abstract class InventoryService {
  Future<PhysicalInventory> getInventoryByDocumentNo(String documentNo);
  Future<List<Locator>> getLocatorsByWarehouse(Reference warehouse);
  Future<List<PhysicalInventoryLine>> getLines(PhysicalInventory inventory,
      [bool isInDispute = false]);
  Future<Product> getProduct(String value);
  Future<List<Reference>> getExistingAsi(int locatorId, int productId);
  Future<PhysicalInventoryLine> mergeLine(PhysicalInventoryLine line,
      {bool isChecked});
  Future<bool> deleteLine(PhysicalInventoryLine line);
}
