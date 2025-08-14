import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';

abstract class OmEvent extends Equatable {
  const OmEvent();

  @override
  List<Object> get props => [];
}

class OmEventDiscardDocument extends OmEvent {}

class OmEventOpenDocumentScanner extends OmEvent {}

class OmEventOpenAsiScanner extends OmEvent {
  final String scanMode;
  final ImtLineEntity line;
  final Map<String, ImtLineEntity> scannedAttributeSets;
  final int locatorId;
  OmEventOpenAsiScanner(
      {required this.scanMode,
      required this.line,
      required this.locatorId,
      this.scannedAttributeSets = const <String, ImtLineEntity>{}})
      : assert(scanMode != null),
        assert(line != null);

  @override
  List<Object> get props => [scanMode, line, locatorId];

  @override
  String toString() =>
      'OmEventOpenAsiScanner { scanMode: $scanMode, line: $line }';
}

class OmEventUpdateOrderLines extends OmEvent {
  final List<ImtLineEntity> movement;

  OmEventUpdateOrderLines({required this.movement});

  @override
  List<Object> get props => [movement];

  @override
  String toString() => 'OmEventLoadOrderLines { po: $movement }';
}

class OmEventLoadLocators extends OmEvent {
  final int warehouseId;

  OmEventLoadLocators({required this.warehouseId});

  @override
  List<Object> get props => [warehouseId];

  @override
  String toString() => 'OmEventLoadLocators { warehouseId: $warehouseId}';
}

class OmEventLoadLocatorsTransit extends OmEvent {
  final int warehouseFromId;

  OmEventLoadLocatorsTransit({required this.warehouseFromId});

  @override
  List<Object> get props => [warehouseFromId];

  @override
  String toString() =>
      'OmEventLoadLocators { warehouseFromId: $warehouseFromId}';
}

class OmEventLoadOrderLines extends OmEvent {
  final OrderMovement movement;

  OmEventLoadOrderLines({required this.movement});

  @override
  List<Object> get props => [movement];

  @override
  String toString() => 'OmEventLoadOrderLines { movement: $movement }';
}

class OmEventLoadImtDocType extends OmEvent {
  final int poDocTypeId;

  OmEventLoadImtDocType({required this.poDocTypeId})
      : assert(poDocTypeId != null);

  @override
  List<Object> get props => [poDocTypeId];

  @override
  String toString() => 'OmEventLoadImtDocType { poDocTypeId: $poDocTypeId }';
}

class OmEventLocatorsChange extends OmEvent {
  final int locatorId;

  OmEventLocatorsChange({required this.locatorId});
}

class OmEventSubmitImt extends OmEvent {
  final ImtEntity receipt;
  final int locatorId, locatorTo;
  final List<ImtLineEntity> lines;

  OmEventSubmitImt(
      {required this.receipt,
      required this.locatorId,
      required this.lines,
      required this.locatorTo});

  @override
  List<Object> get props => [receipt, locatorId, locatorTo];

  @override
  String toString() =>
      'OmEventLoadSubmitImt { po: $receipt, locatorId: $locatorId }';
}
