import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
// import 'package:apps_mobile/features/core/constant/auth_constant.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imt/om/data/datasource/om_datasource.dart';

class OmDataSourceImpl implements OmDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  OmDataSourceImpl({required this.dio, required this.secureStorage});
  Future<String> getAuthData(AuthKey key) async {
    String? data = await secureStorage.read(key: key.toString());
    return data!;
  }

  @override
  Future<Map<String, dynamic>> getOrderMovement(String documentNo) async {
    final clientId = await getAuthData(AuthKey.clientId);

    // Note: cannot use Dio's queryParameters, so manually append the parameter.
    final filter = Uri.encodeComponent('ad_client_id=$clientId'
        ' AND docstatus=\'CO\''
        ' AND documentno=\'$documentNo\'');

    try {
      final response = await dio.get('/windows/order-movement?filter=$filter');
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
  Future<List<dynamic>> getOrderMovementLines(int omId) async {
    final clientId = await getAuthData(AuthKey.clientId);
    final filter = Uri.encodeComponent(
        'ad_client_id=$clientId AND BHP_RMovement_ID=$omId and (qtyDelivered - qtyReceipt) >=1');

    try {
      final response =
          await dio.get('/models/bhp_rv_ordermovementdetail?filter=$filter');
      print('lines imt ++++ ${response.data}');
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

  @override
  Future<List<dynamic>> getLocatorsInTransit(int warehouseFromId) async {
    final clientId = await getAuthData(AuthKey.clientId);

    final filter = Uri.encodeComponent(
        'ad_client_id=$clientId AND m_warehouse_id=$warehouseFromId');

    try {
      final response =
          await dio.get('/windows/warehouse-locators?filter=$filter');
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
