import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imt/om/data/datasource/om_datasource.dart';
import 'package:apps_mobile/features/imt/om/data/model/locator_model.dart';
import 'package:apps_mobile/features/imt/om/data/model/order_movement_model.dart';
import 'package:apps_mobile/features/imt/om/data/model/order_movement_line_model.dart';
import 'package:apps_mobile/features/imt/om/data/model/warehouse_model.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/repository/om_repository.dart';

class OmRepositoryImpl implements OmRepository {
  final _logger = Logger();
  final OmDataSource poDataSource;

  OmRepositoryImpl({required this.poDataSource});

  @override
  Future<Either<CommonError, OrderMovement>> getOrderMovement(
      String documentNo) async {
    try {
      final json = await poDataSource.getOrderMovement(documentNo);
      return Right(OrderMovementModel.fromJson(json));
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<OrderMovementLine>>> getOrderMovementLines(
      int poId) async {
    try {
      final json = await poDataSource.getOrderMovementLines(poId);
      final lines =
          json.map((item) => OrderMovementLineModel.fromJson(item)).toList();
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
      final locators = json.map((item) => LocatorModel.fromJson(item)).toList()
        ..sort((loc1, loc2) => loc1.value.compareTo(loc2.value));

      return Right(locators);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<Warehouse>>> getLocatorsInTransit(
      int warehouseFromId) async {
    try {
      final json = await poDataSource.getLocatorsInTransit(warehouseFromId);
      final locators =
          json.map((item) => WarehouseModel.fromJson(item)).toList();
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
