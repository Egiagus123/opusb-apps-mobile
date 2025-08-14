import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/util/common_generator.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';

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

class OmStateImtLinesUpdate extends OmState {
  final List<ImtLineEntity> lines;

  OmStateImtLinesUpdate({required this.lines});

  @override
  List<Object> get props => [lines];

  @override
  String toString() => 'OmStateOrderLinesLoaded { lines: $lines }';
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
  final ImtLineEntity line;

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

class OmStateLocatorsLoaded extends OmState {
  final List<LocatorEntity> locators;

  OmStateLocatorsLoaded({required this.locators});

  @override
  List<Object> get props => [locators];

  @override
  String toString() => 'OmStateLocatorsLoaded { locators: $locators }';
}

class OmStateLocatorsTransitLoaded extends OmState {
  final int locatorsId;
  final String? locators;

  OmStateLocatorsTransitLoaded({required this.locatorsId, this.locators});

  @override
  List<Object> get props => [locators!];

  @override
  String toString() => 'OmStateLocatorsTransitLoaded { locators: $locators }';
}

class OmStateReceiptLinesCreated extends OmState {
  final List<ImtLineEntity> lines;

  OmStateReceiptLinesCreated({required this.lines});

  @override
  List<Object> get props => [lines];

  @override
  String toString() => 'OmStateOrderLinesLoaded { lines: $lines }';
}

class OmStateImtDocTypeLoaded extends OmState {
  final int id;

  OmStateImtDocTypeLoaded({required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'OmStateImtDocTypeLoaded { id: $id }';
}

class OmStateImtLinesCreated extends OmState {
  final List<ImtLineEntity> lines;

  OmStateImtLinesCreated({required this.lines});

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

class OmStateImtCreated extends OmState {
  final ImtEntity receipt;

  OmStateImtCreated({required this.receipt});

  @override
  List<Object> get props => [receipt];

  @override
  String toString() => 'OmStateImtCreated { receipt: $receipt }';
}

class OmStateLocatorChange extends OmState {
  final int locatorId;

  OmStateLocatorChange({required this.locatorId});

  @override
  List<Object> get props => [locatorId];

  @override
  String toString() => 'OmStateLocatorChange { receipt: $locatorId }';
}
