import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';

abstract class ShipmentRepository {
  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId);

  Future<Either<CommonError, List<ShipmentLineEntity>>> createLines(
      {SalesOrder so, int locatorId});

  Future<Either<CommonError, ShipmentEntity>> submitPoShipment(
      ShipmentEntity data);
}
