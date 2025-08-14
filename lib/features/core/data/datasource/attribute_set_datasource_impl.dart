import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
// import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/features/core/data/datasource/attribute_set_datasource.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';

import '../../../../business_logic/exceptions/server_exception.dart';

class AttributeSetDataSourceImpl implements AttributeSetDataSource {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AttributeSetDataSourceImpl(
      {required Dio dio, required FlutterSecureStorage secureStorage})
      : assert(dio != null),
        assert(secureStorage != null),
        _dio = dio,
        _secureStorage = secureStorage;

// Material Receipt check ASI
  @override
  Future<List<dynamic>> getExistingInstances(
    int productId, {
    String? lot,
    String? serNo,
  }) async {
    String filter = 'm_product_id = $productId AND m_locator_id IS NOT NULL';

    if (lot!.isNotEmpty) {
      filter += " AND lot = '$lot'";
    }

    if (serNo!.isNotEmpty) {
      filter += " AND ser_no = '$serNo'"; // perhatikan nama kolom
    }

    try {
      final response = await _dio.get('/models/rv_storage?filter=$filter');
      print("======== response : ${response.data}");
      return response.data;
    } on DioError catch (e) {
      throw ServerException(e.message ?? 'Unknown DioError');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

// IMT IMF check ASI
  @override
  Future<List<dynamic>> getExistingInstancesWithLocator(
      int locator, int productId,
      {String? lot, String? serNo}) async {
    String filter =
        'm_product_id = $productId AND m_locator_id = $locator and qtyOnHand >0';

    if (lot != null) {
      filter += ' AND lot = \'$lot\'';
    }

    if (serNo != null) {
      filter += ' AND serNo = \'$serNo\'';
    }

    //filter = Uri.encodeComponent(filter);
    print('filter nya ======================== $filter');

    try {
      final response =
          await _dio.get('/windows/bhp-api-storage-on-hand-asi?filter=$filter');
      print("======== response asi : ${response.data}");
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

// Shipment check ASI
  @override
  Future<List<dynamic>> getExistInstancesWithLocator(int locator, int productId,
      {String? lot, String? serNo}) async {
    String filter =
        'm_product_id = $productId AND m_locator_id = $locator and qtyOnHand >0';

    if (lot != null) {
      filter += ' AND lot = \'$lot\'';
    }

    if (serNo != null) {
      filter += ' AND serNo = \'$serNo\'';
    }

    //filter = Uri.encodeComponent(filter);
    print('filter nya $filter');

    try {
      final response = await _dio.get('/models/rv_storage?filter=$filter');
      print("======== response asi : ${response.data}");
      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

// CREATE NEW ASI
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final orgId = Context().orgId;

    data.putIfAbsent(
        'AD_Org_ID',
        () => ReferenceModel(id: (orgId), propertyLabel: '', identifier: '')
            .toJson());

    try {
      final response =
          await _dio.post('/models/m_attributesetinstance', data: data);

      return response.data;
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
