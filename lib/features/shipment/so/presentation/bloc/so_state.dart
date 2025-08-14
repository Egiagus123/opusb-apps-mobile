import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';

abstract class SoState extends Equatable {
  const SoState();

  @override
  List<Object> get props => [];
}

class SoStateInitial extends SoState {}

class SoStateLoading extends SoState {}

class SoStateLineEmpty extends SoState {}

class SoStateDocumentDiscarded extends SoState {}

class SoStateSerialNoDuplication extends SoState {
  final String message;

  SoStateSerialNoDuplication(
      {this.message = 'Product with the same serial no. is already exist'});
}

class SoStateShipmentLinesUpdate extends SoState {
  final List<ShipmentLineEntity> lines;

  SoStateShipmentLinesUpdate({required this.lines});

  @override
  List<Object> get props => [lines];

  @override
  String toString() => 'OmStateOrderLinesLoaded { lines: $lines }';
}

class SoStateScanCanceled extends SoState {
  SoStateScanCanceled();
}

class SoStateDocumentNoScanned extends SoState {
  final String documentNo;

  SoStateDocumentNoScanned({required this.documentNo})
      : assert(documentNo != null);

  @override
  List<Object> get props => [documentNo];

  @override
  String toString() => 'SoStateDocumentNoScanned { documentNo: $documentNo }';
}

class SoStateAsiScanned extends SoState {
  final ShipmentLineEntity line;

  SoStateAsiScanned({required this.line});

  @override
  List<Object> get props => [line];

  @override
  String toString() => 'SoStateAsiScanned { line: $line }';
}

class SoStateDocumentLoaded extends SoState {
  final SalesOrder data;

  SoStateDocumentLoaded({required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'SoStateDocumentLoaded { data: $data }';
}

class SoStateLocatorsLoaded extends SoState {
  final List<LocatorEntity> locators;

  SoStateLocatorsLoaded({required this.locators});

  @override
  List<Object> get props => [locators];

  @override
  String toString() => 'SoStateLocatorsLoaded { locators: $locators }';
}

class SoStateShipmentDocTypeLoaded extends SoState {
  final int id;

  SoStateShipmentDocTypeLoaded({required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'SoStateShipmentDocTypeLoaded { id: $id }';
}

class SoStateShipmentLinesCreated extends SoState {
  final SalesOrder so;
  final List<ShipmentLineEntity> lines;
  final int locatorId;

  SoStateShipmentLinesCreated(
      {required this.so, required this.lines, required this.locatorId});

  @override
  List<Object> get props => [so, lines, locatorId];

  @override
  String toString() =>
      'SoStateOrderLinesLoaded { po: $so, lines: $lines, locatorId: $locatorId }';
}

class SoStateFailed extends SoState {
  final String message;

  SoStateFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SoStateFailed { message: $message }';
}

class SoStateProductAsiUpdated extends SoState {
  final String attribute;

  SoStateProductAsiUpdated({required this.attribute});

  @override
  List<Object> get props => [attribute];

  @override
  String toString() => 'SoStateProductAsiUpdated { attribute: $attribute}';
}

class SoStateShipmentCreated extends SoState {
  final ShipmentEntity shipment;

  SoStateShipmentCreated({required this.shipment});
  @override
  List<Object> get props => [shipment];

  @override
  String toString() => 'SoStateShipmentCreated { shipment: $shipment }';
}
