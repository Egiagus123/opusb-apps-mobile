import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/mr/po/data/datasource/po_datasource.dart';

class PoDataSourceImpl implements PoDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  PoDataSourceImpl({required this.dio, required this.secureStorage});

  Future<String> getAuthData(AuthKey key) async {
    String? data = await secureStorage.read(key: key.toString());
    return data!;
  }

  @override
  Future<Map<String, dynamic>> getPurchaseOrder(String documentNo) async {
    final clientId = await getAuthData(AuthKey.clientId);

    // Note: cannot use Dio's queryParameters, so manually append the parameter.
    final filter = Uri.encodeComponent('ad_client_id=$clientId'
        ' AND docstatus=\'CO\''
        ' AND issotrx=\'N\''
        ' AND documentno=\'$documentNo\'');
    print('filternya >>>>> $filter');

    try {
      final response = await dio.get('/models/c_order?filter=$filter');
      final List<dynamic> po = response.data;
      print('ponya ====$po');

      if (po.length == 0) {
        throw ServerException('Document #$documentNo not found');
      }

      return po[0];
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<dynamic>> getPurchaseOrderLines(int poId) async {
    final clientId = await getAuthData(AuthKey.clientId);
    final filter = Uri.encodeComponent(
        'ad_client_id=$clientId AND c_order_id=$poId AND QtyOrdered <> QtyDelivered AND m_product_id > 0');

    try {
      final response =
          await dio.get('/models/rv_orderlinedetail?filter=$filter');
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<dynamic>> getLocators(int warehouseId) async {
    final clientId = await getAuthData(AuthKey.clientId);
    final filter = Uri.encodeComponent(
        'ad_client_id=$clientId AND m_warehouse_id=$warehouseId');

    try {
      final response = await dio.get('/models/m_locator?filter=$filter');
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
