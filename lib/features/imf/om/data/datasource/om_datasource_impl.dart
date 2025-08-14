import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
// import 'package:apps_mobile/features/core/constant/auth_constant.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imf/om/data/datasource/om_datasource.dart';

class OmIMFDataSourceImpl implements OmIMFDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  OmIMFDataSourceImpl({required this.dio, required this.secureStorage});
  Future<String> getAuthData(AuthKey key) async {
    String? data = await secureStorage.read(key: key.toString());
    return data!;
  }

  @override
  Future<Map<String, dynamic>> getOrderMove(String documentNo) async {
    final clientId = await getAuthData(AuthKey.clientId);

    // Note: cannot use Dio's queryParameters, so manually append the parameter.
    final filter = Uri.encodeComponent('ad_client_id=$clientId'
        ' AND docstatus=\'CO\''
        ' AND documentno=\'$documentNo\'');

    try {
      final response = await dio.get('/models/BHP_RMovement?filter=$filter');
      final List<dynamic> om = response.data;

      if (om.length == 0) {
        throw ServerException('Document #$documentNo not found');
      }

      return om[0];
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<dynamic>> getOrderMoveLines(int omId) async {
    final filter = Uri.encodeComponent(
        'BHP_RMovement_ID=$omId AND (movementQty - qtyDelivered) > 0');
    print('aafaf---- ? $filter');
    try {
      final response =
          await dio.get('/models/bhp_rv_ordermovementdetail?filter=$filter');
      print('aafaf---- ? ${response.data}');
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getWarehouse(int warehouseId) async {
    final clientId = await getAuthData(AuthKey.clientId);
    final filter = Uri.encodeComponent(
        'ad_client_id=$clientId AND m_warehouse_id=$warehouseId');

    try {
      final response =
          await dio.get('/windows/warehouse-locators?filter=$filter');
      final List<dynamic> warehouses = response.data;

      if (warehouses.length == 0) {
        throw ServerException('Warehouse not found');
      }

      return warehouses[0];
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

  @override
  Future<List<dynamic>> getWarehouses(int clientId, int roleId) async {
    if (clientId == null) {
      final id = await getAuthData(AuthKey.clientId);
      clientId = int.tryParse(id) ?? 0;
    }

    if (roleId == null) {
      final id = await getAuthData(AuthKey.roleId);
      roleId = int.tryParse(id) ?? 0;
    }

    final filter = Uri.encodeComponent('AD_Client_ID=$clientId'
        ' AND AD_Role_ID=$roleId'
        ' AND isWarehouseTransit <> \'Y\'');

    print(filter);

    try {
      final response =
          await dio.get('/models/bhp_api_warehouse_access?filter=$filter');
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
