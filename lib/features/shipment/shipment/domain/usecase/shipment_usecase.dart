import 'package:dartz/dartz.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/repository/shipment_repository.dart';

class ShipmentUseCase {
  final ShipmentRepository shipmentRepository;

  ShipmentUseCase(this.shipmentRepository);

  Future<Either<CommonError, int>> getDocTypeId(int poDocTypeId) async {
    return shipmentRepository.getDocTypeId(poDocTypeId);
  }

  Future<Either<CommonError, List<ShipmentLineEntity>>> createLines(
      {SalesOrder? so, int? locatorId}) async {
    return shipmentRepository.createLines(so: so!, locatorId: locatorId!);
  }

  Future<Either<CommonError, ShipmentEntity>> submit(
      ShipmentEntity data) async {
    return shipmentRepository.submitPoShipment(data);
  }
}
