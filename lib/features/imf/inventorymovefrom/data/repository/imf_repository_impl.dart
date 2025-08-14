import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/datasource/imf_datasource.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_line_model.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_model.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/repository/imf_repository.dart';
import 'package:apps_mobile/features/imf/om/data/datasource/om_datasource.dart';
import 'package:apps_mobile/features/imf/om/data/model/order_movement_line_model.dart';

import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

class ImfRepositoryImpl implements ImfRepository {
  final _logger = Logger();
  final OmIMFDataSource _omDataSource;
  final ImfDataSource _receiptDataSource;

  ImfRepositoryImpl(
      {@required OmIMFDataSource? poDataSource,
      @required ImfDataSource? receiptDataSource})
      : assert(poDataSource != null),
        assert(receiptDataSource != null),
        _omDataSource = poDataSource!,
        _receiptDataSource = receiptDataSource!;

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

  static ImfLineEntity copyLine(ImfLineModel line) {
    return line.copy();
  }

  @override
  Future<Either<CommonError, List<ImfLineEntity>>> createLines(
      {@required OrderMovement? om}) async {
    try {
      final omLines = await _omDataSource.getOrderMoveLines(om!.id);
      final List<ImfLineModel> result = [];

      _logger.v('Order movement line count: ${omLines.length}');
      for (var omLine in omLines) {
        final imfLine = ImfLineModel.fromPoLine(
            om: om, omLine: OrderMovementLineModel.fromJson(omLine));

        if (imfLine.attributeSet != null && imfLine.isSerNo!) {
          final orderLine = imfLine.orderLine;
          final reservedQuantity =
              orderLine!.movementQty - orderLine.qtyDelivered;

          // Split shipment lines as many as reserved quantity.
          for (var i = reservedQuantity - 1; i >= 0; --i) {
            final copiedImfLine = imfLine.copy()..quantity = 1;
            result.add(copiedImfLine);
          }
        } else {
          result.add(imfLine);
        }
      }

      _logger.v('IMF Line count: ${result.length}');
      return Right(result);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, ImfEntity>> submitPoReceipt(ImfEntity data) async {
    try {
      final receipt =
          await _receiptDataSource.push((data as ImfModel).toJson());
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
