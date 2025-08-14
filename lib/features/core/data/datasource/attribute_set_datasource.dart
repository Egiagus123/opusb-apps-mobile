abstract class AttributeSetDataSource {
  /// Get the existing ASIs for a specified product.
  Future<List<dynamic>> getExistingInstances(int productId,
      {String lot, String serNo});
  Future<List<dynamic>> getExistInstancesWithLocator(int locator, int productId,
      {String lot, String serNo});
  Future<List<dynamic>> getExistingInstancesWithLocator(
      int locator, int productId,
      {String lot, String serNo});

  /// Create a new ASI record.
  Future<Map<String, dynamic>> create(Map<String, dynamic> data);
}
