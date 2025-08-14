import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/exceptions/user_exception.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';

import '../models/locator.dart';
import '../models/physical_inventory.dart';
import '../models/physical_inventory_line.dart';
import '../services/inventory_service.dart';

class DisputeListStore {
  final log = getLogger('DisputeListStore');
  final InventoryService? inventoryService;

  DisputeListStore({
    required this.inventoryService,
  });

  PhysicalInventory? _inventory;
  PhysicalInventory? get inventory => _inventory!;

  List<PhysicalInventoryLine>? _inventoryLines = <PhysicalInventoryLine>[];
  List<PhysicalInventoryLine>? get inventoryLines => _inventoryLines;

  List<PhysicalInventoryLine>? _lines = <PhysicalInventoryLine>[];
  List<PhysicalInventoryLine>? get lines => _lines;

  String? _query = '';
  String? get query => _query;

  List<PhysicalInventoryLine>? _filteredLines = <PhysicalInventoryLine>[];
  List<PhysicalInventoryLine>? get filteredLines => _filteredLines;

  PhysicalInventoryLine? _line;
  PhysicalInventoryLine? get line => _line;

  Locator? _selectedLocator;
  Locator get selectedLocator => _selectedLocator!;

  bool get isSearchMode => _filteredLines!.isNotEmpty;

  Future<void> init(PhysicalInventory inventory) async {
    log.i('init($inventory)');
    _inventory = inventory;

    // load lines
    _inventoryLines = await inventoryService!.getLines(inventory, true);
    _lines = _inventoryLines;

    // load and select default locator
    final _locatorList =
        await inventoryService!.getLocatorsByWarehouse(inventory.warehouse);
    if (_locatorList.isNotEmpty) {
      _selectedLocator = _locatorList.first;
    }
  }

  PhysicalInventoryLine createLine() {
    log.i('createLine');
    clearSearch();

    return PhysicalInventoryLine(
      id: 0,
      inventory: Reference(id: _inventory!.id),
      locator: Reference(id: _selectedLocator!.id),
      // product: Reference(id: product.id),
      description: '',
      qtyCount: 0,
      // uom: product.uom,
      // productValue: product.value,
      // productName: product.name,
      // isLot: product.isLot,
      // isSerNo: product.isSerNo,
      // isLotMandatory: product.isLotMandatory,
      // isSerNoMandatory: product.isSerNoMandatory,
      isInDispute: true,
    );
  }

  Future<void> mergeLine(PhysicalInventoryLine line) async {
    log.i('merge($line)');
    if (line.description == null || line.description!.isEmpty) {
      throw UserException('Please fill description information');
    }
    PhysicalInventoryLine result = await inventoryService!.mergeLine(line);
    if (line.id! > 0) _lines!.removeWhere((l) => l.id == line.id);
    _lines!.insert(0, result);
  }

  Future<bool> removeItem(int index) async {
    log.i('removeItem($index)');
    bool success = await inventoryService!.deleteLine(_lines![index]);
    if (success) _lines!.removeAt(index);
    return Future.value(success);
  }

  bool searchItem(String query) {
    log.i('searchItem($query)');
    bool resultFound = false;
    clearSearch();
    _filteredLines = _lines!
        .where((line) =>
            line.description!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (_filteredLines!.isNotEmpty) {
      _lines = _filteredLines;
      _query = query;
      resultFound = true;
    }
    return resultFound;
  }

  void clearSearch() {
    log.i('clearSearch()');
    _query = '';
    _filteredLines!.clear();
    _lines = _inventoryLines;
  }
}
