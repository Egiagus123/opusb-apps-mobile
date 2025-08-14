import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/order_line.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

abstract class SoRepository {
  /// Get a purchase order record including its lines.
  Future<Either<CommonError, SalesOrder>> getOrder(String documentNo);

  /// Get the list of SO line with the specified SO ID.
  Future<Either<CommonError, List<OrderLine>>> getOrderLines(int soId);

  /// Get the list of locator with the specified warehouse ID.
  Future<Either<CommonError, List<LocatorEntity>>> getLocators(int warehouseId);
}
