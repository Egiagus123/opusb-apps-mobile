import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';

abstract class ReceiptRepository {
  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId);

  Future<Either<CommonError, List<ReceiptLineEntity>>> createLines(
      {PurchaseOrder po, int locatorId});

  Future<Either<CommonError, ReceiptEntity>> submitPoReceipt(
      ReceiptEntity data);
}
