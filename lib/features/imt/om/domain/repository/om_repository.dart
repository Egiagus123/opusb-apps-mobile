import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/warehouse_entity.dart';

abstract class OmRepository {
  /// Get a purchase order record including its lines.
  Future<Either<CommonError, OrderMovement>> getOrderMovement(
      String documentNo);

  /// Get the list of PO line with the specified PO ID.
  Future<Either<CommonError, List<OrderMovementLine>>> getOrderMovementLines(
      int poId);

  /// Get the list of locator with the specified warehouse ID.
  Future<Either<CommonError, List<LocatorEntity>>> getLocators(int warehouseId);
  Future<Either<CommonError, List<Warehouse>>> getLocatorsInTransit(
      int warehouseFromId);
}
