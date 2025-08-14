import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

abstract class SoEvent extends Equatable {
  const SoEvent();

  @override
  List<Object> get props => [];
}

class SoEventUpdateLines extends SoEvent {
  final List<ShipmentLineEntity> shipmentLine;

  SoEventUpdateLines({required this.shipmentLine});

  @override
  List<Object> get props => [shipmentLine];

  @override
  String toString() => 'OmEventLoadOrderLines { po: $shipmentLine }';
}

class SoEventDiscardDocument extends SoEvent {}

class SoEventOpenDocumentScanner extends SoEvent {}

class SoEventOpenAsiScanner extends SoEvent {
  final String scanMode;
  final ShipmentLineEntity line;
  final Map<String, ShipmentLineEntity> scannedAttributeSets;

  SoEventOpenAsiScanner(
      {required this.scanMode,
      required this.line,
      this.scannedAttributeSets = const <String, ShipmentLineEntity>{}})
      : assert(scanMode != null),
        assert(line != null);

  @override
  List<Object> get props => [scanMode, line];

  @override
  String toString() =>
      'SoEventOpenAsiScanner { scanMode: $scanMode, line: $line }';
}

class SoEventLoadLocators extends SoEvent {
  final int warehouseId;

  SoEventLoadLocators({required this.warehouseId});

  @override
  List<Object> get props => [warehouseId];

  @override
  String toString() => 'SoEventLoadLocators { warehouseId: $warehouseId }';
}

class SoEventLoadOrderLines extends SoEvent {
  final SalesOrder so;
  final int locatorId;

  SoEventLoadOrderLines({required this.so, required this.locatorId});

  @override
  List<Object> get props => [so, locatorId];

  @override
  String toString() =>
      'SoEventLoadOrderLines { so: $so, locatorId: $locatorId }';
}

class SoEventLoadShipmentDocType extends SoEvent {
  final int poDocTypeId;

  SoEventLoadShipmentDocType({required this.poDocTypeId})
      : assert(poDocTypeId != null);

  @override
  List<Object> get props => [poDocTypeId];

  @override
  String toString() =>
      'SoEventLoadShipmentDocType { poDocTypeId: $poDocTypeId }';
}

class SoEventSubmitShipment extends SoEvent {
  final ShipmentEntity shipment;
  final int locatorId;
  final List<ShipmentLineEntity> lines;

  SoEventSubmitShipment(
      {required this.shipment, required this.locatorId, required this.lines});

  @override
  List<Object> get props => [shipment, locatorId];

  @override
  String toString() =>
      'SoEventLoadSubmitShipment { shipment: $shipment, locatorId: $locatorId }';
}
