import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';

import '../models/physical_inventory.dart';
import '../services/inventory_service.dart';

class InventoryFormStore {
  final log = getLogger('InventoryFormStore');
  final InventoryService inventoryService;

  InventoryFormStore({
    required this.inventoryService,
  });

  PhysicalInventory? _inventory;
  PhysicalInventory? get inventory => _inventory;

  Future<void> loadDocument(String documentNo) async {
    log.i('loadDocument($documentNo)');
    _inventory = await inventoryService.getInventoryByDocumentNo(documentNo);
  }

  void clear() {
    _inventory = null;
  }
}
