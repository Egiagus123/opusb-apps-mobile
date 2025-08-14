import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/datasource/imf_datasource.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_model.dart';

class ImfDataSourceImpl implements ImfDataSource {
  final _logger = Logger();
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ImfDataSourceImpl(
      {required Dio dio, required FlutterSecureStorage secureStorage})
      : this._dio = dio,
        this._secureStorage = secureStorage;

  @override
  Future<int> getDocTypeId(int poDocTypeId) async {
    final filter = 'DocBaseType=\'MMM\'';

    try {
      final response = await _dio.get('/models/c_doctype?filter=$filter');
      final List<dynamic> body = response.data;

      if (body.length == 0) {
        throw ServerException('Record not found.');
      }

      _logger.d('Got doctype record ${body[0]}');
      return body[0]['id'];
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ImfModel> push(Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post('/windows/inventory-move-warehouse-from', data: data);

      return ImfModel.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
