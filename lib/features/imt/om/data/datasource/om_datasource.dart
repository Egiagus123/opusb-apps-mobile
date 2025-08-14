

abstract class OmDataSource {

  Future<Map<String, dynamic>> getOrderMovement(String documentNo);
  Future<List<dynamic>> getOrderMovementLines(int poId);
  Future<List<dynamic>> getLocators(int warehouseId);
  Future<List<dynamic>> getLocatorsInTransit(int warehouseFromId);
}