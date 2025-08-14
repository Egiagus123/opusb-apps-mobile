// ignore_for_file: unnecessary_null_comparison

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imt/imt/data/datasource/imt_datasource.dart';
import 'package:apps_mobile/features/imt/imt/data/model/imt_line_model.dart';
import 'package:apps_mobile/features/imt/imt/data/model/imt_model.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/repository/imt_repository.dart';
import 'package:apps_mobile/features/imt/om/data/datasource/om_datasource.dart';
import 'package:apps_mobile/features/imt/om/data/model/order_movement_line_model.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';

class ImtRepositoryImpl implements ImtRepository {
  final _logger = Logger();
  final OmDataSource _poDataSource;
  final ImtDataSource _receiptDataSource;

  ImtRepositoryImpl(
      {required OmDataSource poDataSource,
      required ImtDataSource receiptDataSource})
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
  Future<Either<CommonError, List<ImtLineEntity>>> createLines(
      {OrderMovement? po}) async {
    try {
      final poLines = await _poDataSource.getOrderMovementLines(po!.id);
      final List<ImtLineModel> result = [];

      _logger.v('Order movement line count: ${poLines.length}');
      for (var poLine in poLines) {
        final imtLine = ImtLineModel.fromPoLine(
            po: po, poLine: OrderMovementLineModel.fromJson(poLine));

        if (imtLine.attributeSet != null && imtLine.isSerNo) {
          final orderLine = imtLine.orderLine;
          final reservedQuantity =
              orderLine!.qtyDelivered! - orderLine.qtyReceipt!;

          // Split shipment lines as many as reserved quantity.
          for (var i = reservedQuantity - 1; i >= 0; --i) {
            final copiedImfLine = imtLine.copy()..quantity = 1;
            result.add(copiedImfLine);
          }
        } else {
          result.add(imtLine);
        }
      }

      _logger.v('IMT Line count: ${result.length}');
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
  Future<Either<CommonError, ImtEntity>> submitPoImt(ImtEntity data) async {
    try {
      final receipt =
          await _receiptDataSource.push((data as ImtModel).toJson());
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
