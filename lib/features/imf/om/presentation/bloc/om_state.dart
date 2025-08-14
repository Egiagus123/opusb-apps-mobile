import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/core/util/common_generator.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

abstract class OmState extends Equatable {
  const OmState();

  @override
  List<Object> get props => [];
}

class OmStateInitial extends OmState {}

class OmStateLoading extends OmState {}

class OmStateLineEmpty extends OmState {}

class OmStateDocumentDiscarded extends OmState {}

class OmStateSerialNoDuplication extends OmState {
  final String message;

  OmStateSerialNoDuplication(
      {this.message = 'Product with the same serial no. is already exist'});
}

class OmStateScanCanceled extends OmState {
  final String message;

  OmStateScanCanceled({this.message = 'Scan canceled'});
}

class OmStateDocumentNoScanned extends OmState {
  final String documentNo;

  OmStateDocumentNoScanned({required this.documentNo})
      : assert(documentNo != null);

  @override
  List<Object> get props => [documentNo];

  @override
  String toString() => 'OmStateDocumentNoScanned { documentNo: $documentNo }';
}

class OmStateAsiScanned extends OmState {
  final ImfLineEntity line;

  OmStateAsiScanned({required this.line});

  @override
  List<Object> get props => [line];

  @override
  String toString() => 'OmStateAsiScanned { line: $line }';
}

class OmStateDocumentLoaded extends OmState {
  final OrderMovement data;

  OmStateDocumentLoaded({required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'OmStateDocumentLoaded { data: $data }';
}

class OmStateWarehousesLoaded extends OmState {
  final List<WarehouseEntity> warehouses;

  OmStateWarehousesLoaded({required this.warehouses});

  @override
  List<Object> get props => [warehouses];

  @override
  String toString() => 'OmStateWarehousesLoaded { warehouses: $warehouses }';
}

class OmStateLocatorsLoaded extends OmState {
  final List<LocatorEntity> locators;
  final bool? isFrom;

  OmStateLocatorsLoaded({required this.locators, this.isFrom});

  @override
  List<Object> get props => [locators];

  @override
  String toString() => 'OmStateLocatorsLoaded { locators: $locators }';
}

class OmStateInTransitLocatorLoaded extends OmState {
  final ReferenceEntity locator;

  OmStateInTransitLocatorLoaded(this.locator);
}

class OmStateReceiptDocTypeLoaded extends OmState {
  final int id;

  OmStateReceiptDocTypeLoaded({required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'OmStateReceiptDocTypeLoaded { id: $id }';
}

class OmStateReceiptLinesCreated extends OmState {
  final List<ImfLineEntity>? lines;

  OmStateReceiptLinesCreated({required this.lines});

  @override
  List<Object> get props => [lines!];

  @override
  String toString() => 'OmStateOrderLinesLoaded { lines: $lines }';
}

class OmStateImfLinesUpdate extends OmState {
  final List<ImfLineEntity> lines;

  OmStateImfLinesUpdate({required this.lines});

  @override
  List<Object> get props => [lines];

  @override
  String toString() => 'OmStateOrderLinesLoaded { lines: $lines }';
}

class OmStateFailed extends OmState {
  final String message;

  OmStateFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'OmStateFailed { message: $message }';
}

class OmStateProductAsiUpdated extends OmState {
  final String attribute;

  OmStateProductAsiUpdated({required this.attribute});

  @override
  List<Object> get props => [attribute];

  @override
  String toString() => 'OmStateProductAsiUpdated { attribute: $attribute}';
}

class OmStateImfCreated extends OmState {
  final ImfEntity imf;

  OmStateImfCreated({required this.imf});

  @override
  List<Object> get props => [imf];

  @override
  String toString() => 'OmStateReceiptCreated { receipt: $imf }';
}

class OmStateLocatorChange extends OmState {
  final int locatorId;

  OmStateLocatorChange({required this.locatorId});

  @override
  List<Object> get props => [locatorId];

  @override
  String toString() => 'OmStateReceiptCreated { receipt: $locatorId }';
}
