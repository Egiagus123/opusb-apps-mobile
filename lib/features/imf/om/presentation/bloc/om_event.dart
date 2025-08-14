import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';

abstract class OmEvent extends Equatable {
  const OmEvent();

  @override
  List<Object> get props => [];
}

class OmEventDiscardDocument extends OmEvent {}

class OmEventOpenDocumentScanner extends OmEvent {}

class OmEventOpenAsiScanner extends OmEvent {
  final String scanMode;
  final ImfLineEntity line;
  final Map<String, ImfLineEntity> scannedAttributeSets;
  final int locatorId;
  OmEventOpenAsiScanner(
      {required this.scanMode,
      required this.line,
      required this.locatorId,
      this.scannedAttributeSets = const <String, ImfLineEntity>{}})
      : assert(scanMode != null),
        assert(line != null);

  @override
  List<Object> get props => [line];

  @override
  String toString() => 'OmEventOpenAsiScanner { line: $line }';
}

class OmEventLoadWarehouses extends OmEvent {}

class OmEventLoadLocators extends OmEvent {
  final bool? isFrom;
  final int warehouseId;

  OmEventLoadLocators({required this.warehouseId, this.isFrom});

  @override
  List<Object> get props => [warehouseId];

  @override
  String toString() => 'OmEventLoadLocators { warehouseId: $warehouseId }';
}

class OmEventLoadInTransitLocator extends OmEvent {
  final int warehouseId;

  OmEventLoadInTransitLocator({required this.warehouseId});
}

class OmEventLocatorsChange extends OmEvent {
  final int locatorId;

  OmEventLocatorsChange({required this.locatorId});
}

class OmEventLoadOrderLines extends OmEvent {
  final OrderMovement movement;

  OmEventLoadOrderLines({required this.movement});

  @override
  List<Object> get props => [movement];

  @override
  String toString() => 'OmEventLoadOrderLines { po: $movement }';
}

class OmEventUpdateOrderLines extends OmEvent {
  final List<ImfLineEntity> movement;

  OmEventUpdateOrderLines({required this.movement});

  @override
  List<Object> get props => [movement];

  @override
  String toString() => 'OmEventLoadOrderLines { po: $movement }';
}

class OmEventRateUOM extends OmEvent {
  final int productID;

  OmEventRateUOM({required this.productID});

  @override
  List<Object> get props => [productID];

  @override
  String toString() => 'Product ID for UOM Rate Checking { id : $productID }';
}

class OmEventLoadImfDocType extends OmEvent {
  final int imfDocTypeId;

  OmEventLoadImfDocType({required this.imfDocTypeId})
      : assert(imfDocTypeId != null);
  @override
  List<Object> get props => [imfDocTypeId];

  @override
  String toString() => 'OmEventLoadImfDocType { imfDocTypeId: $imfDocTypeId }';
}

class OmEventSubmitImf extends OmEvent {
  final ImfEntity imf;
  final int locatorId;
  final int locatorToId;
  final List<ImfLineEntity> lines;

  OmEventSubmitImf(
      {required this.imf,
      required this.locatorId,
      required this.locatorToId,
      required this.lines});
  @override
  List<Object> get props => [imf, locatorId, locatorToId];

  @override
  String toString() =>
      'OmEventSubmitImf { imf: $imf, locatorId: $locatorId, locatorToId: $locatorToId }';
}
