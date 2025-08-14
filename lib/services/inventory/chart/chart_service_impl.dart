import 'package:apps_mobile/business_logic/models/inventory/chartdetail.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/chart/chart_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChartServiceImpl implements ChartService {
  final Dio dio;
  ChartServiceImpl({required this.dio});

  @override
  Future<List<DataDetail>> getChartData() async {
    final storage = sl<FlutterSecureStorage>();
    final clientId = await storage.read(key: AuthKey.clientId.toString());

    List<DataDetail> chart = <DataDetail>[];
    try {
      Dio dio = new Dio();
      dio.options.headers["Authorization"] =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1OTczMDIwMjN9.fSDETRnOwozz1bmPhbaklbleHSvRZJuKtr1gXJ9SV0M";
      final response = await dio.get(
          'https://dev-cubejs.opusb.id/cubejs-api/v1/load?query={\"measures\": [\"YTDWorkOrder.totalwo\"],\"dimensions\": [\"YTDWorkOrder.wostatus\"],\"filters\": [{\"member\": \"YTDWorkOrder.clientId\", \"operator\": \"equals\",\"values\": [\"$clientId\"]}]}');

      // var responseJson = json.decode(response.data);
      // return (responseJson['data'] as List)
      //     .map((p) => DataDetail.fromJson(p))
      //     .toList();
      // return chart = DataDetail.fromJson(response.data) as List;
      var data = (response.data['data'] as List);
      List<DataDetail> newListData =
          data.map((i) => DataDetail.fromJson(i)).toList();
      chart = newListData.reversed.toList();
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return chart;
  }
}
