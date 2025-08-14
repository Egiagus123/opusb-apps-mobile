import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';

abstract class PoRepository {
  /// Get a purchase order record including its lines.
  Future<Either<CommonError, PurchaseOrder>> getOrder(String documentNo);

  /// Get the list of PO line with the specified PO ID.
  Future<Either<CommonError, List<OrderLine>>> getOrderLines(int poId);

  /// Get the list of locator with the specified warehouse ID.
  Future<Either<CommonError, List<LocatorEntity>>> getLocators(int warehouseId);
}
