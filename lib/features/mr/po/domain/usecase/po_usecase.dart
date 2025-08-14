import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/po/domain/repository/po_repository.dart';

class PoUseCase {
  final PoRepository poRepository;

  PoUseCase(this.poRepository);

  Future<Either<CommonError, PurchaseOrder>> getRecord(
      {required String documentNo}) async {
    return poRepository.getOrder(documentNo);
  }

  Future<Either<CommonError, List<OrderLine>>> createReceiptLines(
      {required int poId}) async {
    return poRepository.getOrderLines(poId);
  }

  Future<Either<CommonError, List<LocatorEntity>>> getLocators(
      {required int warehouseId}) async {
    return poRepository.getLocators(warehouseId);
  }
}
