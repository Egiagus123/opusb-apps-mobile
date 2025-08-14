import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/mr/po/data/datasource/po_datasource.dart';
import 'package:apps_mobile/features/mr/po/data/model/order_line_model.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/data/datasource/receipt_datasource.dart';
import 'package:apps_mobile/features/mr/receipt/data/model/receipt_line_model.dart';
import 'package:apps_mobile/features/mr/receipt/data/model/receipt_model.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/repository/receipt_repository.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final _logger = Logger();
  final PoDataSource _poDataSource;
  final ReceiptDataSource _receiptDataSource;

  ReceiptRepositoryImpl(
      {required PoDataSource poDataSource,
      required ReceiptDataSource receiptDataSource})
      : assert(poDataSource != null),
        assert(receiptDataSource != null),
        _poDataSource = poDataSource,
        _receiptDataSource = receiptDataSource;

  @override
  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId) async {
    try {
      final id = await _receiptDataSource.getDocTypeId(poDocTypeId);
      return Right(id);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<ReceiptLineEntity>>> createLines(
      {PurchaseOrder? po, int? locatorId}) async {
    try {
      final poLines = await _poDataSource.getPurchaseOrderLines(po!.id);
      final List<ReceiptLineEntity> result = [];

      _logger.v('PO Line count: ${poLines.length}');
      for (var poLine in poLines) {
        final receiptLine = ReceiptLineModel.fromPoLine(
            po: po,
            locatorId: locatorId,
            poLine: OrderLineModel.fromJson(poLine));

        if (receiptLine.attributeSet != null && receiptLine.isSerNo!) {
          for (var i = receiptLine.qtyEntered! - 1; i >= 0; --i) {
            final copiedReceiptLine = receiptLine.copy()
              ..quantity = 1
              ..orderLine!.qtyReserved = 1;

            result.add(copiedReceiptLine);
          }
        } else {
          result.add(receiptLine);
        }
      }

      _logger.v('Receipt Line count: ${result.length}');
      return Right(result);
    } catch (e) {
      final error = e.toString();
      _logger.e(error);

      return Left(ServerError(message: error));
    }
  }

  @override
  Future<Either<CommonError, ReceiptEntity>> submitPoReceipt(
      ReceiptEntity data) async {
    try {
      final receipt =
          await _receiptDataSource.push((data as ReceiptModel).toJson());
      return Right(receipt);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
