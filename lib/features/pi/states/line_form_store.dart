import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/exceptions/not_found_exception.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';

import '../models/physical_inventory_line.dart';
import '../services/inventory_service.dart';

class LineFormStore {
  final log = getLogger('LineFormStore');
  final InventoryService inventoryService;

  LineFormStore({
    required this.inventoryService,
  });

  PhysicalInventoryLine? _line;
  PhysicalInventoryLine? get line => _line;

  List<Reference> _asiList = <Reference>[];
  List<Reference> get asiList => _asiList;

  int _asiId = 0;
  int get asiId => _asiId;

  Future<void> init(PhysicalInventoryLine line) async {
    log.i('init($line)');
    _line = PhysicalInventoryLine(
      id: line.id,
      inventory: Reference(id: line.inventory!.id),
      locator: Reference(id: line.locator!.id),
      product: line.product != null ? Reference(id: line.product!.id) : null,
      qtyCount: line.qtyCount,
      description: line.description,
      uom: line.uom,
      productValue: line.productValue,
      productName: line.productName,
      isLot: line.isLot,
      isSerNo: line.isSerNo,
      isLotMandatory: line.isLotMandatory,
      isSerNoMandatory: line.isSerNoMandatory,
      isInDispute: line.isInDispute,
    );
    if (!_line!.isInDispute!) {
      _asiList = await inventoryService.getExistingAsi(
          line.locator!.id, line.product!.id);
      if (line.asi!.id > 0) _asiId = line.asi!.id;
    }
  }

  void dispose() {
    log.i('dispose');
    _line = null;
    _asiList = <Reference>[];
    _asiId = 0;
  }

  void setAsiId(int asiId) {
    log.i('setAsiId($asiId)');
    _asiId = asiId;
    _line!.asi = Reference(id: _asiId);
  }

  void scanAsi(String barcode) {
    log.i('scanAsi($barcode)');
    final resultList = _asiList
        .where((asi) => asi.identifier!
            .trim()
            .toLowerCase()
            .contains(barcode.trim().toLowerCase()))
        .toList();
    if (resultList.isNotEmpty) {
      setAsiId(resultList.first.id);
    } else {
      throw NotFoundException('$barcode not found');
    }
  }
}
