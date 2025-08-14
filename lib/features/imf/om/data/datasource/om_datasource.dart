abstract class OmIMFDataSource {
  Future<Map<String, dynamic>> getOrderMove(String documentNo);
  Future<List<dynamic>> getOrderMoveLines(int omId);
  Future<Map<String, dynamic>> getWarehouse(int warehouseId);
  Future<List<dynamic>> getLocators(int warehouseId);
  Future<List<dynamic>> getWarehouses(int clientId, int roleId);
}
