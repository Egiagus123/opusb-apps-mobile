import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/uom_convertion.dart';
import 'package:apps_mobile/features/imf/om/domain/repository/om_repository.dart';

class OmIMFUseCase {
  final OmIMFRepository omRepository;

  OmIMFUseCase(this.omRepository);

  Future<Either<CommonError, OrderMovement>> getRecord(
      {required String documentNo}) async {
    return omRepository.getOrderMovement(documentNo);
  }

  Future<Either<CommonError, List<WarehouseEntity>>> getWarehouses(
      {int? clientId, int? roleId, int? orgId}) async {
    return omRepository.getWarehouses();
  }

  Future<Either<CommonError, List<OrderMovementLine>>> createReceiptLines(
      {required int? poId}) async {
    return omRepository.getOrderMovementLines(poId!);
  }

  Future<Either<CommonError, List<LocatorEntity>>> getLocators(
      {required int? warehouseId}) async {
    return omRepository.getLocators(warehouseId!);
  }

  Future<Either<CommonError, ReferenceEntity>> getInTransitLocator(
      {required int warehouseId}) async {
    return omRepository.getInTransitLocator(warehouseId);
  }

//    Future<Either<CommonError, List<UOMConvertion>>> getUOMConvertion(int productId)async {
// return omRepository.getUOMConvertion(productId)
//    }
}
