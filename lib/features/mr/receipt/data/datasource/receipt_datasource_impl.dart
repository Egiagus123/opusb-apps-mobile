import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/mr/receipt/data/datasource/receipt_datasource.dart';
import 'package:apps_mobile/features/mr/receipt/data/model/receipt_model.dart';

class ReceiptDataSourceImpl implements ReceiptDataSource {
  final _logger = Logger();
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ReceiptDataSourceImpl(
      {required Dio dio, required FlutterSecureStorage secureStorage})
      : assert(dio != null),
        this._dio = dio,
        this._secureStorage = secureStorage;

  @override
  Future<int> getDocTypeId(int poDocTypeId) async {
    final filter =
        'c_doctype_id = (SELECT c_doctypeshipment_id FROM c_doctype WHERE c_doctype_id = $poDocTypeId)';

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
    } catch (e) {
      _logger.e('Error getting receipt document type.');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ReceiptModel> push(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/windows/material-receipt', data: data);

      return ReceiptModel.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      _logger.e('Error submitting receipt entry.');
      throw ServerException(e.toString());
    }
  }
}
