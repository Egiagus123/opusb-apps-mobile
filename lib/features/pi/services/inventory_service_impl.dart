import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/exceptions/multiple_result_found_exception.dart';
import 'package:apps_mobile/business_logic/exceptions/not_found_exception.dart';
import 'package:apps_mobile/business_logic/exceptions/user_exception.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/features/pi/models/locator.dart';

import '../models/physical_inventory.dart';
import '../models/physical_inventory_line.dart';
import '../models/product.dart';
import 'inventory_service.dart';

class InventoryServiceImpl implements InventoryService {
  final log = getLogger('InventoryServiceImpl');
  final Dio dio;

  InventoryServiceImpl({
    required this.dio,
  });

  @override
  Future<PhysicalInventory> getInventoryByDocumentNo(String documentNo) async {
    log.i('getInventoryByDocumentNo($documentNo)');
    PhysicalInventory inventory;
    try {
      final response = await dio
          .get("/windows/physical-inventory?filter=DocumentNo='$documentNo'");

      var data = (response.data as List);
      if (data.length > 1) {
        throw MultipleResultFoundException(
            'Multiple result found for $documentNo');
      } else if (data.isEmpty) {
        throw NotFoundException('$documentNo not found');
      } else {
        inventory = PhysicalInventory.fromJson(data.single);
        if (inventory.processed) {
          throw UserException('${inventory.documentNo} already processed');
        }
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(inventory);
    return inventory;
  }

  @override
  Future<List<Locator>> getLocatorsByWarehouse(Reference warehouse) async {
    log.i('getLocatorsByWarehouse($warehouse)');
    List<Locator> locatorList = <Locator>[];
    try {
      final response = await dio
          .get("/models/m_locator?filter=M_Warehouse_ID=${warehouse.id}");
      var data = (response.data as List);
      if (data.isEmpty) {
        throw NotFoundException(
            'No locator found for warehouse ${warehouse.identifier}');
      } else {
        locatorList = data.map((i) => Locator.fromJson(i)).toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(locatorList);
    return locatorList;
  }

  @override
  Future<Product> getProduct(String value) async {
    log.i('getProduct($value)');
    Product? product;
    product ??= await _getProductByColumnValue('upc', value);
    product ??= await _getProductByColumnValue('value', value);
    if (product == null) throw NotFoundException('$value not found');
    log.d(product);
    return product;
  }

  Future<Product> _getProductByColumnValue(String column, String value) async {
    log.i('_getProductByColumnValue(column: $column, value: $value)');
    Product? product;
    try {
      final response = await dio.get(
          "/windows/bhp_api_product?filter=trim(upper($column))=trim(upper('$value'))");
      var data = (response.data as List);
      if (data.length > 1) {
        throw MultipleResultFoundException('Multiple result found for $value');
      } else if (data.isNotEmpty) {
        product = Product.fromJson(data.single);
      } else {
        product = null;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(product);
    return product!;
  }

  @override
  Future<List<PhysicalInventoryLine>> getLines(PhysicalInventory inventory,
      [bool isInDispute = false]) async {
    log.i('getLines(inventory)');
    List<PhysicalInventoryLine> lineList = <PhysicalInventoryLine>[];
    try {
      final response = await dio.get("/windows/bhp_api_inventory_line"
          "?filter=m_inventory_id=${inventory.id}"
          " and isindispute='${isInDispute ? 'Y' : 'N'}'");
      var data = (response.data as List);
      if (data.isNotEmpty) {
        lineList = data.map((i) => PhysicalInventoryLine.fromJson(i)).toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(lineList);
    return lineList;
  }

  @override
  Future<List<Reference>> getExistingAsi(int locatorId, int productId) async {
    log.i('getExistingAsi(locatorId: $locatorId, productId: $productId)');
    List<Reference> asiList = <Reference>[];
    try {
      final response = await dio.get("/windows/bhp_api_storageonhand"
          // "?filter=m_locator_id=$locatorId"
          "?filter=m_product_id=$productId"
          " and m_attributesetinstance_id > 0");
      var data = (response.data as List);
      if (data.isNotEmpty) {
        var dirtyAsiList = data
            .map(
                (json) => Reference.fromJson(json['M_AttributeSetInstance_ID']))
            .toList();
        // remove duplicate
        asiList = LinkedHashSet<Reference>.from(dirtyAsiList).toList();
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(asiList);
    return asiList;
  }

  @override
  Future<PhysicalInventoryLine> mergeLine(PhysicalInventoryLine line,
      {bool? isChecked}) async {
    log.i('mergeLine($line, $isChecked)');
    await _checkDocumentValidity(line.inventory!.id);
    if (isChecked != null) line.isChecked = isChecked;
    PhysicalInventoryLine result;
    try {
      var response;
      final String tabName =
          line.isInDispute! ? 'in-dispute' : 'inventory-count-line';
      if (line.id == 0) {
        response = await dio.post(
          "/windows/physical-inventory"
          "/tabs/inventory-count/${line.inventory!.id}/$tabName",
          data: line.toJson(),
        );
      } else {
        response = await dio.put(
          "/windows/physical-inventory/tabs/$tabName/${line.id}/",
          data: line.toJson(),
        );
      }
      result = PhysicalInventoryLine.fromJson(response.data);
      response = await dio.get(
          "/windows/bhp_api_inventory_line?filter=m_inventoryline_id=${result.id}");
      var data = (response.data as List);
      if (data.isNotEmpty) {
        result =
            data.map((i) => PhysicalInventoryLine.fromJson(i)).toList().single;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(result);
    return result;
  }

  @override
  Future<bool> deleteLine(PhysicalInventoryLine line) async {
    log.i('deleteLine($line)');
    await _checkDocumentValidity(line.inventory!.id);
    bool success = false;
    try {
      final String tabName =
          line.isInDispute! ? 'in-dispute' : 'inventory-count-line';
      final response = await dio
          .delete("/windows/physical-inventory/tabs/$tabName/${line.id}/");
      success = response.statusCode == 200;
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(success);
    return Future.value(success);
  }

  Future<bool> _checkDocumentValidity(int inventoryId) async {
    log.i('checkDocumentValidity($inventoryId)');
    bool isValid = false;
    try {
      final response = await dio.get(
          "/windows/physical-inventory/tabs/inventory-count/$inventoryId/");
      PhysicalInventory inventory = PhysicalInventory.fromJson(response.data);
      if (inventory.processed) {
        throw UserException('${inventory.documentNo} already processed');
      } else {
        isValid = true;
      }
    } on DioError catch (e) {
      throw e.error.toString();
    }
    log.d(isValid);
    return Future.value(isValid);
  }
}
