import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/mr/po/data/datasource/po_datasource.dart';
import 'package:apps_mobile/features/mr/po/data/model/locator_model.dart';
import 'package:apps_mobile/features/mr/po/data/model/order_line_model.dart';
import 'package:apps_mobile/features/mr/po/data/model/purchase_order_model.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/po/domain/repository/po_repository.dart';

class PoRepositoryImpl implements PoRepository {
  final _logger = Logger();
  final PoDataSource poDataSource;

  PoRepositoryImpl({required this.poDataSource});

  @override
  Future<Either<CommonError, PurchaseOrder>> getOrder(String documentNo) async {
    try {
      final json = await poDataSource.getPurchaseOrder(documentNo);
      return Right(PurchaseOrderModel.fromJson(json));
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<OrderLine>>> getOrderLines(int poId) async {
    try {
      final json = await poDataSource.getPurchaseOrderLines(poId);
      final lines = json.map((item) => OrderLineModel.fromJson(item)).toList();
      return Right(lines);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<LocatorEntity>>> getLocators(
      int warehouseId) async {
    try {
      final json = await poDataSource.getLocators(warehouseId);
      final locators = json.map((item) => LocatorModel.fromJson(item)).toList();
      return Right(locators);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
