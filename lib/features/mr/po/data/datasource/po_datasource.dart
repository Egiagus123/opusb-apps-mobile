

abstract class PoDataSource {

  Future<Map<String, dynamic>> getPurchaseOrder(String documentNo);
  Future<List<dynamic>> getPurchaseOrderLines(int poId);
  Future<List<dynamic>> getLocators(int warehouseId);

}