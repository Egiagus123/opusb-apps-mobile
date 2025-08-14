// ignore_for_file: unnecessary_null_comparison

import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';

import '../models/locator.dart';
import '../models/physical_inventory.dart';
import '../models/physical_inventory_line.dart';
import '../models/product.dart';
import '../services/inventory_service.dart';

class LineListStore {
  final log = getLogger('LineListStore');
  final InventoryService inventoryService;

  LineListStore({
    required this.inventoryService,
  });

  PhysicalInventory? _inventory;
  PhysicalInventory? get inventory => _inventory;

  List<Locator> _locatorList = <Locator>[];
  List<Locator> get locatorList => _locatorList;

  Locator? _selectedLocator;
  Locator? get selectedLocator => _selectedLocator;

  List<PhysicalInventoryLine>? _lines = <PhysicalInventoryLine>[];
  List<PhysicalInventoryLine>? get lines => _lines;

  String _query = '';
  String get query => _query;

  List<PhysicalInventoryLine> _filteredLines = <PhysicalInventoryLine>[];
  List<PhysicalInventoryLine> get filteredLines => _filteredLines;

  Map<int, List<PhysicalInventoryLine>> _linesPerLocator =
      Map<int, List<PhysicalInventoryLine>>();
  Map<int, List<PhysicalInventoryLine>> get linesPerLocator => _linesPerLocator;

  PhysicalInventoryLine? _line;
  PhysicalInventoryLine? get line => _line;

  Product? _product;
  Product? get product => _product;

  bool get isSearchMode => _filteredLines.isNotEmpty;

  Future<void> init(PhysicalInventory inventory) async {
    log.i('init($inventory)');
    _inventory = inventory;

    // load and select default locator
    _locatorList =
        await inventoryService.getLocatorsByWarehouse(inventory.warehouse);
    if (_locatorList.isNotEmpty) {
      _selectedLocator = _locatorList.first;
    }

    // load lines
    List<PhysicalInventoryLine> inventoryLines =
        await inventoryService.getLines(inventory);
    inventoryLines.sort((a, b) =>
        a.productValue!.toLowerCase().compareTo(b.productValue!.toLowerCase()));
    _linesPerLocator.clear();
    _locatorList
        .forEach((l) => _linesPerLocator[l.id] = <PhysicalInventoryLine>[]);
    inventoryLines
        .forEach((line) => _linesPerLocator[line.locator!.id]!.add(line));
    _lines = _linesPerLocator[_selectedLocator!.id];
  }

  void setSelectedLocator(String value) {
    log.i('setSelectedLocator($value)');
    _selectedLocator = _locatorList.firstWhere((l) => l.value == value);
    _lines = _linesPerLocator[_selectedLocator!.id];
  }

  Future<PhysicalInventoryLine> getOrCreateLineByProduct(String value) async {
    log.i('getOrCreateLineByProduct($value)');
    clearSearch();
    Product product = await inventoryService.getProduct(value);
    var lineProductList =
        _lines!.where((l) => l.product!.id == product.id).toList();
    if (lineProductList.isNotEmpty) {
      return lineProductList.first;
    } else {
      return PhysicalInventoryLine(
        id: 0,
        inventory: Reference(id: _inventory!.id),
        locator: Reference(id: _selectedLocator!.id),
        product: Reference(id: product.id),
        description: '',
        qtyCount: 0,
        uom: product.uom,
        productValue: product.value,
        productName: product.name,
        isLot: product.isLot,
        isSerNo: product.isSerNo,
        isLotMandatory: product.isLotMandatory,
        isSerNoMandatory: product.isSerNoMandatory,
        isInDispute: false,
      );
    }
  }

  Future<void> mergeLine(PhysicalInventoryLine line) async {
    log.i('merge($line)');
    PhysicalInventoryLine result = await inventoryService.mergeLine(line);
    if (line.id! > 0) _lines!.removeWhere((l) => l.id == line.id);
    _lines!.insert(0, result);
  }

  Future<void> markLine(PhysicalInventoryLine line, bool isChecked) async {
    log.i('markLine($line, $isChecked)');
    PhysicalInventoryLine result =
        await inventoryService.mergeLine(line, isChecked: isChecked);
    if (result != null) line.isChecked = result.isChecked;
  }

  Future<bool> removeItem(int index) async {
    log.i('removeItem($index)');
    bool success = await inventoryService.deleteLine(_lines![index]);
    if (success) _lines!.removeAt(index);
    return Future.value(success);
  }

  bool searchItem(String query) {
    log.i('searchItem($query)');
    bool resultFound = false;
    clearSearch();
    _filteredLines = _lines!
        .where((line) =>
            line.keywords!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (_filteredLines.isNotEmpty) {
      _lines = _filteredLines;
      _query = query;
      resultFound = true;
    }
    return resultFound;
  }

  void clearSearch() {
    log.i('clearSearch()');
    _query = '';
    _filteredLines.clear();
    _lines = _linesPerLocator[_selectedLocator!.id];
  }

  void sort(bool sortAsc) {
    log.i('sort(sortAsc: $sortAsc)');
    if (sortAsc) {
      _lines!.sort((a, b) => a.productValue!
          .toLowerCase()
          .compareTo(b.productValue!.toLowerCase()));
    } else {
      _lines!.sort((a, b) => b.productValue!
          .toLowerCase()
          .compareTo(a.productValue!.toLowerCase()));
    }
  }
}
