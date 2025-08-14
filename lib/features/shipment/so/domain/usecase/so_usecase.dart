import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/order_line.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';
import 'package:apps_mobile/features/shipment/so/domain/repository/so_repository.dart';

class SoUseCase {
  final SoRepository poRepository;

  SoUseCase(this.poRepository);

  Future<Either<CommonError, SalesOrder>> getRecord(
      {required String documentNo}) async {
    return poRepository.getOrder(documentNo);
  }

  Future<Either<CommonError, List<OrderLine>>> createShipmentLines(
      {required int poId}) async {
    return poRepository.getOrderLines(poId);
  }

  Future<Either<CommonError, List<LocatorEntity>>> getLocators(
      {required int warehouseId}) async {
    return poRepository.getLocators(warehouseId);
  }
}
