import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/shipment/shipment/data/datasource/shipment_datasource.dart';
import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_model.dart';

class ShipmentDataSourceImpl implements ShipmentDataSource {
  final _logger = Logger();
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ShipmentDataSourceImpl(
      {required Dio dio, required FlutterSecureStorage secureStorage})
      : this._dio = dio,
        this._secureStorage = secureStorage;

  @override
  Future<int> getDocTypeId(int poDocTypeId) async {
    final filter = 'c_doctype_id = $poDocTypeId';

    try {
      final response = await _dio.get('/models/c_doctype?filter=$filter');

      final List<dynamic> body = response.data;

      if (body.length == 0) {
        throw ServerException('Document type is not found.');
      }

      _logger.d('Got doctype record ${body[0]}');
      return body[0]['id'];
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }

  @override
  Future<ShipmentModel> push(Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post('/windows/shipment-customer', data: data);

      return ShipmentModel.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }
}
