import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/shipment/so/data/datasource/so_datasource.dart';
import 'package:apps_mobile/features/shipment/so/data/model/locator_model.dart';
import 'package:apps_mobile/features/shipment/so/data/model/order_line_model.dart';
import 'package:apps_mobile/features/shipment/so/data/model/sales_order_model.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/order_line.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';
import 'package:apps_mobile/features/shipment/so/domain/repository/so_repository.dart';

class SoRepositoryImpl implements SoRepository {
  final SoDataSource soDataSource;

  SoRepositoryImpl({required this.soDataSource});

  @override
  Future<Either<CommonError, SalesOrder>> getOrder(String documentNo) async {
    try {
      final json = await soDataSource.getSalesOrder(documentNo);
      print('jsonnya========= $json');
      return Right(SalesOrderModel.fromJson(json));
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on AccessDeniedException catch (_) {
      return Left(ServerError(
          message: 'You\'re not allowed to access document #$documentNo'));
    } on DocumentNotFoundException catch (e) {
      return Left(ServerError(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }

  @override
  Future<Either<CommonError, List<OrderLine>>> getOrderLines(int poId) async {
    try {
      final json = await soDataSource.getSalesOrderLines(poId);
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
      final json = await soDataSource.getLocators(warehouseId);
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
