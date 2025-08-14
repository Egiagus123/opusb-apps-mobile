import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imt/imt/data/datasource/imt_datasource.dart';
import 'package:apps_mobile/features/imt/imt/data/model/imt_model.dart';

class ImtDataSourceImpl implements ImtDataSource {
  final _logger = Logger();
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ImtDataSourceImpl(
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
  Future<ImtModel> push(Map<String, dynamic> data) async {
    try {
      final response =
          await _dio.post('/windows/inventory-move-warehouse-to', data: data);

      return ImtModel.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
