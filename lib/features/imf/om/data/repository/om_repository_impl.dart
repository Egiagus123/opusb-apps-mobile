import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
// import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/features/core/data/model/warehouse_model.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/imf/om/data/datasource/om_datasource.dart';
import 'package:apps_mobile/features/imf/om/data/model/locator_model.dart';
import 'package:apps_mobile/features/imf/om/data/model/order_movement_line_model.dart';
import 'package:apps_mobile/features/imf/om/data/model/order_movement_model.dart';

import 'package:apps_mobile/features/imf/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imf/om/domain/repository/om_repository.dart';

class OmIMFRepositoryImpl implements OmIMFRepository {
  final _logger = Logger();
  final OmIMFDataSource omDataSource;
  final FlutterSecureStorage secureStorage;

  OmIMFRepositoryImpl(
      {required this.omDataSource, required this.secureStorage});

  Future<String> getAuthData(AuthKey key) async {
    String? data = await secureStorage.read(key: key.toString());
    return data!;
  }

  @override
  Future<Either<CommonError, OrderMovement>> getOrderMovement(
      String documentNo) async {
    try {
      final json = await omDataSource.getOrderMove(documentNo);
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
  Future<Either<CommonError, List<WarehouseEntity>>> getWarehouses(
      {int? clientId, int? roleId, int? orgId}) async {
    final clientId = await getAuthData(AuthKey.clientId);
    final roleId = await getAuthData(AuthKey.roleId);

    int a = int.parse(clientId);
    int b = int.parse(roleId);

    try {
      final json = await omDataSource.getWarehouses(a, b);
      final warehouses = json.map((item) => WarehouseModel.fromJson(item));
      return Right(
          warehouses.toList()..sort((w1, w2) => w1.name.compareTo(w2.name)));
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
      final json = await omDataSource.getOrderMoveLines(poId);
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
      final json = await omDataSource.getLocators(warehouseId);
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
  Future<Either<CommonError, ReferenceEntity>> getInTransitLocator(
      int warehouseId) async {
    try {
      final json = await omDataSource.getWarehouse(warehouseId);
      final warehouse = WarehouseModel.fromJson(json);
      return Right(warehouse.inTransitLocator);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
