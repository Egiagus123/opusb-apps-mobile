import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:apps_mobile/features/core/constant/auth_constant.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/shipment/so/data/datasource/so_datasource.dart';

// TODO Refactor to use global DioError handler.
class SoDataSourceImpl implements SoDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  SoDataSourceImpl({required this.dio, required this.secureStorage});

  Future<String> getAuthData(AuthKey key) async {
    String? data = await secureStorage.read(key: key.toString());
    return data!;
  }

  @override
  Future<Map<String, dynamic>> getSalesOrder(String documentNo) async {
    final clientId = await getAuthData(AuthKey.clientId);

    // Note: cannot use Dio's queryParameters, so manually append the parameter.
    final filter = Uri.encodeComponent('ad_client_id=$clientId'
        ' AND docstatus=\'CO\''
        ' AND issotrx=\'Y\''
        ' AND documentno=\'$documentNo\''
        ' AND c_doctype_id IN (SELECT c_doctype_id'
        ' FROM c_doctype'
        ' WHERE ad_client_id = $clientId'
        ' AND isactive = \'Y\''
        ' AND c_doctypepicklist_id IS NULL)');

    try {
      final response = await dio.get('/models/c_order?filter=$filter');
      final List<dynamic> po = response.data;

      if (po.length == 0) {
        throw DocumentNotFoundException('Document #$documentNo not found');
      }

      return po[0];
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }

  @override
  Future<List<dynamic>> getSalesOrderLines(int poId) async {
    final clientId = await getAuthData(AuthKey.clientId);
    final filter = Uri.encodeComponent('ad_client_id=$clientId'
        ' AND c_order_id=$poId'
        ' AND QtyOrdered <> QtyDelivered'
        ' AND m_product_id > 0'
        ' AND C_Charge_ID IS NULL');

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
    final filter = Uri.encodeComponent('ad_client_id=$clientId'
        ' AND m_warehouse_id=$warehouseId');

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
