import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:apps_mobile/business_logic/models/assetshipmentmodel/container_model.dart';
import 'package:apps_mobile/business_logic/models/assetshipmentmodel/shipment_model.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/tooltrf_header.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../service_locator.dart';
import 'offline_service.dart';
import 'dart:convert';

class OfflineServiceImpl implements OfflineService {
  final Dio dio;
  OfflineServiceImpl({required this.dio});
  final storage = sl<FlutterSecureStorage>();

  @override
  Future<ToolsTrfHeader> pushTrxAsset(ToolsTrfHeader data) async {
    try {
      final jsonMap = jsonEncode((data).toJson());

      final response =
          await dio.post('/windows/temporarytablemobile', data: jsonMap);

      return ToolsTrfHeader.fromJson(response.data);
    } on DioError catch (e) {
      throw e.error.toString();
    }
  }

  @override
  Future<bool> insertShipment(ShipmentOfflineModel object) async {
    bool? saved;
    try {
      final responsecontainer = await dio
          .get("/models/TRM_M_CONT?filter=value = '${object.container}'");
      if (responsecontainer.statusCode == 200) {
        var data = responsecontainer.data as List;
        List<ContainerShipment> container =
            data.map((e) => ContainerShipment.fromJson(e)).toList();
        if (container.isNotEmpty) {
          ShipmentTemporarry shipmentTemporarry = ShipmentTemporarry(
            container: Reference(id: container.first.id),
            Tare_Weight: object.tareweight.toString(),
            containerNo: object.container,
            qtyEntered: object.qtyentered,
            quantity: object.quantity.toString(),
            weight1: object.weight1.toString(),
          );
          final response = await dio.post('/models/TRM_Temporary_Weight',
              data: shipmentTemporarry);
          if (response.statusCode == 201) {
            saved = true;
          }
        } else {
          saved = false;
        }
      }
    } on DioError catch (e) {
      saved = false;
      // throw e.error;
    }
    return saved!;
  }
}
