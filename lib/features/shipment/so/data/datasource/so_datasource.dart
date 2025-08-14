

abstract class SoDataSource {

  Future<Map<String, dynamic>> getSalesOrder(String documentNo);
  Future<List<dynamic>> getSalesOrderLines(int soId);
  Future<List<dynamic>> getLocators(int warehouseId);

}