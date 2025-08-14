import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';

abstract class PoEvent extends Equatable {
  const PoEvent();

  @override
  List<Object> get props => [];
}

class PoEventDiscardDocument extends PoEvent {}

class PoEventOpenDocumentScanner extends PoEvent {}

class PoEventOpenAsiScanner extends PoEvent {
  final String scanMode;
  final ReceiptLineEntity line;
  final Map<String, ReceiptLineEntity> scannedAttributeSets;

  PoEventOpenAsiScanner(
      {required this.scanMode,
      required this.line,
      this.scannedAttributeSets = const <String, ReceiptLineEntity>{}})
      : assert(scanMode != null),
        assert(line != null);

  @override
  List<Object> get props => [scanMode, line];

  @override
  String toString() =>
      'PoEventOpenAsiScanner { scanMode: $scanMode, line: $line }';
}

class PoEventUpdateLines extends PoEvent {
  final List<ReceiptLineEntity> receiptLine;

  PoEventUpdateLines({required this.receiptLine});

  @override
  List<Object> get props => [receiptLine];

  @override
  String toString() => 'OmEventLoadOrderLines { po: $receiptLine }';
}

class PoEventLoadLocators extends PoEvent {
  final int warehouseId;

  PoEventLoadLocators({required this.warehouseId});

  @override
  List<Object> get props => [warehouseId];

  @override
  String toString() => 'PoEventLoadLocators { warehouseId: $warehouseId }';
}

class PoEventLoadPurchaseOrderLines extends PoEvent {
  final PurchaseOrder po;
  final int locatorId;

  PoEventLoadPurchaseOrderLines({required this.po, required this.locatorId});

  @override
  List<Object> get props => [po, locatorId];

  @override
  String toString() =>
      'PoEventLoadOrderLines { po: $po, locatorId: $locatorId }';
}

class PoEventLoadReceiptDocType extends PoEvent {
  final int poDocTypeId;

  PoEventLoadReceiptDocType({required this.poDocTypeId})
      : assert(poDocTypeId != null);

  @override
  List<Object> get props => [poDocTypeId];

  @override
  String toString() =>
      'PoEventLoadReceiptDocType { poDocTypeId: $poDocTypeId }';
}

class PoEventSubmitReceipt extends PoEvent {
  final ReceiptEntity receipt;
  final int locatorId;
  final List<ReceiptLineEntity> lines;

  PoEventSubmitReceipt(
      {required this.receipt, required this.locatorId, required this.lines});

  @override
  List<Object> get props => [receipt, locatorId];

  @override
  String toString() =>
      'PoEventLoadSubmitReceipt { po: $receipt, locatorId: $locatorId }';
}
