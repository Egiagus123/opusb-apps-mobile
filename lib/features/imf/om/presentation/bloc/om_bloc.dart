import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_model.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/usecase/imf_usecase.dart';
import 'package:apps_mobile/features/imf/om/domain/usecase/om_usecase.dart';
import 'package:path/path.dart';

import '../../../../../business_logic/scanbarcode/ScanPage.dart';
import './bloc.dart';

class OmBloc extends Bloc<OmEvent, OmState> {
  final _logger = Logger();
  final OmIMFUseCase _poUseCase;
  final ImfUseCase _receiptUseCase;
  final AttributeSetUseCase _attributeSetUseCase;

  OmBloc({
    required OmIMFUseCase poUseCase,
    required ImfUseCase receiptUseCase,
    required AttributeSetUseCase attributeSetUseCase,
  })  : _poUseCase = poUseCase,
        _receiptUseCase = receiptUseCase,
        _attributeSetUseCase = attributeSetUseCase,
        super(OmStateInitial());

  @override
  Stream<OmState> mapEventToState(OmEvent event, BuildContext context) async* {
    if (event is OmEventOpenAsiScanner) {
      yield* _scanAsi(event, context);
    } else if (event is OmEventOpenDocumentScanner) {
      yield* _scanDocumentNo(event, context);
    } else if (event is OmEventDiscardDocument) {
      yield OmStateDocumentDiscarded();
    } else if (event is OmEventLoadImfDocType) {
      yield* _loadImfDocType(event);
    } else if (event is OmEventLoadWarehouses) {
      yield* _loadWarehouses();
    } else if (event is OmEventLoadLocators) {
      yield* _loadLocators(event);
    } else if (event is OmEventLoadInTransitLocator) {
      yield* _loadInTransitLocator(event);
    } else if (event is OmEventLoadOrderLines) {
      yield* _loadLines(event);
    } else if (event is OmEventSubmitImf) {
      yield* _submitDocument(event);
    } else if (event is OmEventLocatorsChange) {
      yield OmStateLocatorChange(locatorId: event.locatorId);
    } else if (event is OmEventUpdateOrderLines) {
      yield OmStateImfLinesUpdate(lines: event.movement);
    } else if (event is OmEventRateUOM) {
      yield* _getUOMRate(event);
    }
  }

  // Helper buat parsing error lebih singkat
  String _parseError(dynamic error) {
    if (error is CommonError) {
      return error.toString();
    } else {
      return error.toString();
    }
  }

  Stream<OmState> _scanDocumentNo(
      OmEventOpenDocumentScanner event, BuildContext context) async* {
    try {
      // Pindai barcode untuk mendapatkan documentNo
      final documentNo =
          await scanBarcode(context); // Gunakan scanBarcode(context)

      _logger.i('Got document no.: $documentNo');

      if (documentNo == null || documentNo == 'Cancelled') {
        yield OmStateScanCanceled();
      } else {
        yield OmStateDocumentNoScanned(documentNo: documentNo);
        yield OmStateLoading();

        // Ambil data berdasarkan documentNo yang dipindai
        final data = await _poUseCase.getRecord(documentNo: documentNo);

        yield data.fold(
          (err) {
            final message = _parseError(err);
            _logger.e('Failed getting PO document. $message');
            return OmStateFailed(message: message);
          },
          (po) => OmStateDocumentLoaded(data: po),
        );
      }
    } catch (e) {
      _logger.e('Error scanning document: $e');
      yield OmStateFailed(message: 'Scan failed. Please try again.');
    }
  }

  Stream<OmState> _scanAsi(
      OmEventOpenAsiScanner event, BuildContext context) async* {
    try {
      final scanMode = event.scanMode;

      // Pindai barcode untuk mendapatkan attributeNo
      final attributeNo =
          await scanBarcode(context); // Gunakan scanBarcode(context)

      if (attributeNo == null || attributeNo == 'Cancelled') {
        yield OmStateScanCanceled();
      } else {
        yield* _processAsi(
          scanMode: scanMode,
          line: event.line,
          attributeNo: attributeNo, // Menggunakan attributeNo yang dipindai
          scannedAttributeSets: event.scannedAttributeSets,
          locator: event.locatorId,
        );
      }
    } catch (e) {
      _logger.e('Error scanning ASI: $e');
      yield OmStateFailed(message: 'Scan failed. Please try again.');
    }
  }

  Stream<OmState> _loadImfDocType(OmEventLoadImfDocType event) async* {
    yield OmStateLoading();
    final data = await _receiptUseCase.getDocTypeId(event.imfDocTypeId);
    yield data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e('Failed getting receipt docType ID. $message');
        return OmStateFailed(message: message);
      },
      (id) => OmStateReceiptDocTypeLoaded(id: id),
    );
  }

  Stream<OmState> _loadWarehouses() async* {
    yield OmStateLoading();
    final data = await _poUseCase.getWarehouses();
    yield data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e('Failed getting warehouses. $message');
        return OmStateFailed(message: message);
      },
      (warehouses) => OmStateWarehousesLoaded(warehouses: warehouses),
    );
  }

  Stream<OmState> _loadLocators(OmEventLoadLocators event) async* {
    yield OmStateLoading();
    final data = await _poUseCase.getLocators(warehouseId: event.warehouseId);
    yield data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e('Failed getting locators. $message');
        return OmStateFailed(message: message);
      },
      (locators) =>
          OmStateLocatorsLoaded(locators: locators, isFrom: event.isFrom!),
    );
  }

  Stream<OmState> _loadInTransitLocator(
      OmEventLoadInTransitLocator event) async* {
    yield OmStateLoading();
    final data =
        await _poUseCase.getInTransitLocator(warehouseId: event.warehouseId);
    yield data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e('Failed getting in-transit locator. $message');
        return OmStateFailed(message: message);
      },
      (locator) => OmStateInTransitLocatorLoaded(locator),
    );
  }

  Stream<OmState> _loadLines(OmEventLoadOrderLines event) async* {
    yield OmStateLoading();
    final data = await _receiptUseCase.createLines(po: event.movement);
    yield data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e('Failed getting order lines. $message');
        return OmStateFailed(message: message);
      },
      (lines) {
        if (lines.isEmpty) {
          return OmStateLineEmpty();
        }
        return OmStateReceiptLinesCreated(lines: lines);
      },
    );
  }

  Stream<OmState> _submitDocument(OmEventSubmitImf event) async* {
    yield OmStateLoading();
    _logger.d('Submitting Inventory Move From...');
    final imf = event.imf;
    _logger.i('Header IMF: ${jsonEncode((imf as ImfModel).toJson())}');

    final selectedLines = event.lines.where((line) => line.selected).toList();

    for (var line in selectedLines) {
      line.line = 0;
      line.locator = ReferenceModel(id: event.locatorId);
      line.locatorTo = ReferenceModel(id: event.locatorToId);
      _logger.v('- Line: ${jsonEncode(line.toJson())}');
    }

    imf.lines = selectedLines;
    final data = await _receiptUseCase.submit(imf);
    yield data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e('Failed submitting the document. $message');
        return OmStateFailed(message: message);
      },
      (imf) => OmStateImfCreated(imf: imf),
    );
  }

  Stream<OmState> _processAsi({
    required String scanMode,
    required ImfLineEntity line,
    required String attributeNo,
    required int locator,
    required Map<String, ImfLineEntity> scannedAttributeSets,
  }) async* {
    if (scannedAttributeSets.containsKey(line.attributeNo)) {
      scannedAttributeSets.remove(line.attributeNo);
    }

    final isAsiAlreadyUsed = scannedAttributeSets.containsKey(attributeNo);

    _logger.i('Got attribute no.: $attributeNo, exists: $isAsiAlreadyUsed');
    if (isAsiAlreadyUsed) {
      yield OmStateSerialNoDuplication();
    } else {
      yield OmStateLoading();
      final product = await _getProduct(scanMode, line, attributeNo, locator);
      yield product.fold(
        (error) => OmStateFailed(message: error),
        (product) {
          _logger.i('Product with the same lot/serial no. found in storage');
          line.attributeSetInstance = product.asi;
          if (line.isSerNo!) {
            line
              ..attributeNo = attributeNo
              ..selected = true;
            scannedAttributeSets[attributeNo] = line;
          }
          return OmStateAsiScanned(line: line);
        },
      );
    }
  }

  Future<Either<String, StorageEntity>> _getProduct(String scanMode,
      ImfLineEntity line, String attributeNo, int locator) async {
    final data = await _attributeSetUseCase.getExistingInstancesWithLocator(
      locator,
      line.product.id,
      lot: scanMode == 'lot' ? attributeNo : null,
      serNo: scanMode == 'serNo' ? attributeNo : null,
    );

    return data.fold(
      (err) {
        final message = _parseError(err);
        _logger.e(message);
        return Left(message);
      },
      (list) {
        if (list.isEmpty) {
          return Left('Product is not available');
        }
        return Right(list[0]);
      },
    );
  }

  Stream<OmState> _getUOMRate(OmEventRateUOM event) async* {
    // Empty handler, lanjut di next iteration
  }
}
