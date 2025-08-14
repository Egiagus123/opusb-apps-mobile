import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/repository/om_repository.dart';

class OmUseCase {
  final OmRepository poRepository;

  OmUseCase(this.poRepository);

  Future<Either<CommonError, OrderMovement>> getRecord(
      {required String documentNo}) async {
    return poRepository.getOrderMovement(documentNo);
  }

  Future<Either<CommonError, List<OrderMovementLine>>> createReceiptLines(
      {required int poId}) async {
    return poRepository.getOrderMovementLines(poId);
  }

  Future<Either<CommonError, List<LocatorEntity>>> getLocators(
      {required int warehouseId}) async {
    return poRepository.getLocators(warehouseId);
  }

  Future<Either<CommonError, List<Warehouse>>> getLocatorsInTransit(
      {required int warehouseFromId}) async {
    return poRepository.getLocatorsInTransit(warehouseFromId);
  }
}
