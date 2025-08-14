import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/core/error/exception.dart';
import 'package:apps_mobile/features/shipment/shipment/data/datasource/shipment_datasource.dart';
import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_line_model.dart';
import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_model.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/repository/shipment_repository.dart';
import 'package:apps_mobile/features/shipment/so/data/datasource/so_datasource.dart';
import 'package:apps_mobile/features/shipment/so/data/model/order_line_model.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  final _logger = Logger();
  final SoDataSource _poDataSource;
  final ShipmentDataSource _shipmentDataSource;

  ShipmentRepositoryImpl(
      {required SoDataSource poDataSource,
      required ShipmentDataSource shipmentDataSource})
      : assert(poDataSource != null),
        assert(shipmentDataSource != null),
        _poDataSource = poDataSource,
        _shipmentDataSource = shipmentDataSource;

  @override
  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId) async {
    try {
      final id = await _shipmentDataSource.getDocTypeId(poDocTypeId);
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
  Future<Either<CommonError, List<ShipmentLineEntity>>> createLines(
      {SalesOrder? so, int? locatorId}) async {
    try {
      final soLines = await _poDataSource.getSalesOrderLines(so!.id);
      final List<ShipmentLineModel> result = [];

      _logger.v('SO Line count: ${soLines.length}');
      for (var soLine in soLines) {
        final shipmentLine = ShipmentLineModel.fromPoLine(
            so: so,
            locatorId: locatorId,
            soLine: OrderLineModel.fromJson(soLine));

        if (shipmentLine.attributeSet != null && shipmentLine.isSerNo!) {
          // Split shipment lines as many as SO line quantity.
          for (var i = shipmentLine.qtyEntered! - 1; i >= 0; --i) {
            final copiedShipmentLine = shipmentLine.copy()
              ..quantity = 1
              ..orderLine!.qtyReserved = 1;

            result.add(copiedShipmentLine);
          }
        } else {
          result.add(shipmentLine);
        }
      }

      _logger.v('Shipment Line count: ${result.length}');
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
  Future<Either<CommonError, ShipmentEntity>> submitPoShipment(
      ShipmentEntity data) async {
    try {
      final shipment =
          await _shipmentDataSource.push((data as ShipmentModel).toJson());
      return Right(shipment);
    } on UnauthorizedException catch (_) {
      return Left(ClientError(message: 'Session expired. Please login'));
    } on ServerException catch (e) {
      return Left(ServerError(message: e.message));
    } catch (e) {
      return Left(UnknownError(message: e.toString()));
    }
  }
}
