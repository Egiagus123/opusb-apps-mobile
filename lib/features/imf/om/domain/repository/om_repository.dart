import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/uom_convertion.dart';

abstract class OmIMFRepository {
  /// Get a purchase order record including its lines.
  Future<Either<CommonError, OrderMovement>> getOrderMovement(
      String documentNo);

  Future<Either<CommonError, List<WarehouseEntity>>> getWarehouses(
      {int clientId, int roleId, int orgId});

  /// Get the list of PO line with the specified PO ID.
  Future<Either<CommonError, List<OrderMovementLine>>> getOrderMovementLines(
      int poId);

  /// Get the list of locator with the specified warehouse ID.
  Future<Either<CommonError, List<LocatorEntity>>> getLocators(int warehouseId);

  /// Get in-transit locator ID of the specified warehouse.
  Future<Either<CommonError, ReferenceEntity>> getInTransitLocator(
      int warehouseId);

  //Get UOM Convertion Available
  // Future<Either<CommonError, UOMConvertion>> getUOMConvertion(int productId);
}
