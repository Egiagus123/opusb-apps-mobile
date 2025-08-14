import 'dart:async';
import 'dart:convert';

import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/imt/imt/data/model/imt_model.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/usecase/imt_usecase.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/usecase/om_usecase.dart';

import './bloc.dart';

class OmBloc extends Bloc<OmEvent, OmState> {
  final _logger = Logger();
  final OmUseCase _poUseCase;
  final ImtUseCase _receiptUseCase;
  final AttributeSetUseCase _attributeSetUseCase;

  OmBloc({
    required OmUseCase poUseCase,
    required ImtUseCase receiptUseCase,
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
    } else if (event is OmEventLoadImtDocType) {
      yield* _loadImtDocType(event);
    } else if (event is OmEventLoadLocators) {
      yield* _loadLocators(event);
    } else if (event is OmEventLoadLocatorsTransit) {
      yield* _loadLocatorsTransit(event);
    } else if (event is OmEventLoadOrderLines) {
      yield* _loadLines(event);
    } else if (event is OmEventSubmitImt) {
      yield* _submitDocument(event);
    } else if (event is OmEventLocatorsChange) {
      yield* _getLocator(event);
    } else if (event is OmEventUpdateOrderLines) {
      yield* _updateLines(event);
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

        // Mendapatkan data berdasarkan documentNo
        final data = await _poUseCase.getRecord(documentNo: documentNo);
        yield data.fold(
          (err) {
            final message = _extractErrorMessage(err);
            _logger.e('Failed getting PO document. $message');
            return OmStateFailed(message: message);
          },
          (po) => OmStateDocumentLoaded(data: po),
        );
      }
    } catch (e) {
      _logger.e('Error during document scan: $e');
      yield OmStateFailed(message: 'Scan failed. Please try again.');
    }
  }

  Stream<OmState> _scanAsi(
      OmEventOpenAsiScanner event, BuildContext context) async* {
    final scanMode = event.scanMode;

    // Pindai barcode untuk mendapatkan attributeNo menggunakan BuildContext dari event
    final attributeNo =
        await scanBarcode(context); // Gunakan scanBarcode(context)

    _logger.i('Got attribute no.: $attributeNo');

    // Jika pemindaian dibatalkan atau null
    if (attributeNo == null || attributeNo == 'Cancelled') {
      yield OmStateScanCanceled();
    } else {
      // Proses lebih lanjut dengan attributeNo yang dipindai
      yield* _processAsi(
        scanMode: scanMode,
        line: event.line,
        attributeNo: attributeNo,
        scannedAttributeSets: event.scannedAttributeSets,
        locator: event.locatorId,
      );
    }
  }

  Stream<OmState> _loadImtDocType(OmEventLoadImtDocType event) async* {
    yield OmStateLoading();
    final data = await _receiptUseCase.getDocTypeId(event.poDocTypeId);

    yield data.fold(
      (err) {
        final message = _extractErrorMessage(err);
        _logger.e('Failed getting order movement docType ID. $message');
        return OmStateFailed(message: message);
      },
      (id) => OmStateImtDocTypeLoaded(id: id),
    );
  }

  Stream<OmState> _loadLocators(OmEventLoadLocators event) async* {
    yield OmStateLoading();
    final data = await _poUseCase.getLocators(warehouseId: event.warehouseId);

    yield data.fold(
      (err) {
        final message = _extractErrorMessage(err);
        _logger.e('Failed getting locators. $message');
        return OmStateFailed(message: message);
      },
      (locators) => OmStateLocatorsLoaded(locators: locators),
    );
  }

  Stream<OmState> _loadLocatorsTransit(
      OmEventLoadLocatorsTransit event) async* {
    yield OmStateLoading();
    final data = await _poUseCase.getLocatorsInTransit(
      warehouseFromId: event.warehouseFromId,
    );

    final result =
        data.fold((_) => null, (list) => list.isNotEmpty ? list[0] : null);

    if (result != null) {
      yield OmStateLocatorsTransitLoaded(
        locators: result.inTransit.identifier,
        locatorsId: result.inTransit.id,
      );
    } else {
      yield OmStateFailed(message: 'Failed to load transit locator.');
    }
  }

  Stream<OmState> _getLocator(OmEventLocatorsChange event) async* {
    yield OmStateLocatorChange(locatorId: event.locatorId);
  }

  Stream<OmState> _loadLines(OmEventLoadOrderLines event) async* {
    yield OmStateLoading();
    final data = await _receiptUseCase.createLines(po: event.movement);

    yield data.fold(
      (err) {
        final message = _extractErrorMessage(err);
        _logger.e('Failed getting order lines. $message');
        return OmStateFailed(message: message);
      },
      (lines) {
        if (lines.isEmpty) {
          return OmStateLineEmpty();
        }
        return OmStateImtLinesCreated(lines: lines);
      },
    );
  }

  Stream<OmState> _processAsi({
    required String scanMode,
    required ImtLineEntity line,
    required String attributeNo,
    required int locator,
    required Map<String, ImtLineEntity> scannedAttributeSets,
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
      final productResult =
          await _getProduct(scanMode, line, attributeNo, locator);

      yield productResult.fold(
        (error) => OmStateFailed(message: error),
        (product) {
          if (product == null) {
            _logger.e('Lot/serial no. doesn\'t exist');
            return OmStateFailed(message: 'Product is not available');
          }
          _logger.i(
              'Product with the same lot/serial no. is found in the storage');

          line.attributeSetInstance = product.asi;

          if (line.isSerNo) {
            line
              ..attributeNo = attributeNo
              ..selected = true;
            scannedAttributeSets.putIfAbsent(attributeNo, () => line);
          }

          return OmStateAsiScanned(line: line);
        },
      );
    }
  }

  Stream<OmState> _updateLines(OmEventUpdateOrderLines event) async* {
    yield OmStateImtLinesUpdate(lines: event.movement);
  }

  Stream<OmState> _submitDocument(OmEventSubmitImt event) async* {
    yield OmStateLoading();
    _logger.d('Submitting Inventory Move To...');

    final receipt = event.receipt;
    receipt.lines = List<ImtLineEntity>.from(
      event.lines.where((line) => line.selected).map((line) {
        line.line = 0;
        line.locator = ReferenceModel(id: event.locatorId);
        line.locatorTo = ReferenceModel(id: event.locatorTo);
        return line;
      }),
    );

    final data = await _receiptUseCase.submit(receipt);

    yield data.fold(
      (err) {
        final message = _extractErrorMessage(err);
        _logger.e('Failed submitting the document. $message');
        return OmStateFailed(message: message);
      },
      (imf) => OmStateImtCreated(receipt: imf),
    );
  }

  Future<Either<String, StorageEntity?>> _getProduct(
    String scanMode,
    ImtLineEntity line,
    String attributeNo,
    int locator,
  ) async {
    final data = await _attributeSetUseCase.getExistInstancesWithLocator(
      locator,
      line.product.id,
      lot: scanMode == 'lot' ? attributeNo : null,
      serNo: scanMode == 'serNo' ? attributeNo : null,
    );

    return data.fold(
      (err) {
        final message = _extractErrorMessage(err);
        _logger.e(message);
        return Left(message);
      },
      (list) => Right(list.isEmpty ? null : list[0]),
    );
  }

  String _extractErrorMessage(CommonError err) {
    if (err is ClientError || err is ServerError || err is UnknownError) {
      return err.toString();
    }
    return 'An unknown error occurred';
  }
}
