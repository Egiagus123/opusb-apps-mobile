import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';

abstract class PoState extends Equatable {
  const PoState();

  @override
  List<Object> get props => [];
}

class PoStateInitial extends PoState {}

class PoStateLoading extends PoState {}

class PoStateLineEmpty extends PoState {}

class PoStateDocumentDiscarded extends PoState {}

class PoStateSerialNoDuplication extends PoState {
  final String message;

  PoStateSerialNoDuplication(
      {this.message = 'Product with the same serial no. is already exist'});
}

class PoStateScanCanceled extends PoState {}

class PoStateDocumentNoScanned extends PoState {
  final String documentNo;

  PoStateDocumentNoScanned({required this.documentNo})
      : assert(documentNo != null);

  @override
  List<Object> get props => [documentNo];

  @override
  String toString() => 'PoStateDocumentNoScanned { documentNo: $documentNo }';
}

class PoStateReceiptLinesUpdate extends PoState {
  final List<ReceiptLineEntity> lines;

  PoStateReceiptLinesUpdate({required this.lines});

  @override
  List<Object> get props => [lines];

  @override
  String toString() => 'PoStateReceiptLinesUpdate { lines: $lines }';
}

class PoStateAsiScanned extends PoState {
  final ReceiptLineEntity line;

  PoStateAsiScanned({required this.line});

  @override
  List<Object> get props => [line];

  @override
  String toString() => 'PoStateAsiScanned { line: $line }';
}

class PoStateDocumentLoaded extends PoState {
  final PurchaseOrder data;

  PoStateDocumentLoaded({required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'PoStateDocumentLoaded { data: $data }';
}

class PoStateLocatorsLoaded extends PoState {
  final List<LocatorEntity> locators;

  PoStateLocatorsLoaded({required this.locators});

  @override
  List<Object> get props => [locators];

  @override
  String toString() => 'PoStateLocatorsLoaded { locators: $locators }';
}

class PoStateReceiptDocTypeLoaded extends PoState {
  final int id;

  PoStateReceiptDocTypeLoaded({required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'PoStateReceiptDocTypeLoaded { id: $id }';
}

class PoStateReceiptLinesCreated extends PoState {
  final PurchaseOrder po;
  final List<ReceiptLineEntity> lines;
  final int locatorId;

  PoStateReceiptLinesCreated(
      {required this.po, required this.lines, required this.locatorId});

  @override
  List<Object> get props => [po, lines, locatorId];

  @override
  String toString() =>
      'PoStateOrderLinesLoaded { po: $po, lines: $lines, locatorId: $locatorId }';
}

class PoStateFailed extends PoState {
  final String message;
  //final Exception exception;
  PoStateFailed({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PoStateFailed { message: $message }';
}

class PoStateProductAsiUpdated extends PoState {
  final String attribute;

  PoStateProductAsiUpdated({required this.attribute});

  @override
  List<Object> get props => [attribute];

  @override
  String toString() => 'PoStateProductAsiUpdated { attribute: $attribute}';
}

class PoStateReceiptCreated extends PoState {
  final ReceiptEntity receipt;

  PoStateReceiptCreated({required this.receipt});

  @override
  List<Object> get props => [receipt];

  @override
  String toString() => 'PoStateReceiptCreated { receipt: $receipt }';
}
