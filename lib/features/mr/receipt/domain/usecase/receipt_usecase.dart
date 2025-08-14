import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/repository/receipt_repository.dart';

class ReceiptUseCase {
  final ReceiptRepository receiptRepository;

  ReceiptUseCase(this.receiptRepository);

  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId) async {
    return receiptRepository.getDocTypeId(poDocTypeId);
  }

  Future<Either<CommonError, List<ReceiptLineEntity>>> createLines(
      {PurchaseOrder? po, int? locatorId}) async {
    return receiptRepository.createLines(po: po!, locatorId: locatorId!);
  }

  Future<Either<CommonError, ReceiptEntity>> submit(ReceiptEntity data) async {
    return receiptRepository.submitPoReceipt(data);
  }
}
