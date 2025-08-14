// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/data/model/attribute_set_instance_model.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/attribute_set_instance.dart';
import 'package:apps_mobile/features/core/domain/entity/storage_entity.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/core/error/common_error.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/usecase/po_usecase.dart';
import 'package:apps_mobile/features/mr/receipt/data/model/receipt_model.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/usecase/receipt_usecase.dart';

import './bloc.dart';

class PoBloc extends Bloc<PoEvent, PoState> {
  final _logger = Logger();
  final PoUseCase _poUseCase;
  final ReceiptUseCase _receiptUseCase;
  final AttributeSetUseCase _attributeSetUseCase;

  PoBloc({
    required PoUseCase poUseCase,
    required ReceiptUseCase receiptUseCase,
    required AttributeSetUseCase attributeSetUseCase,
  })  : _poUseCase = poUseCase,
        _receiptUseCase = receiptUseCase,
        _attributeSetUseCase = attributeSetUseCase,
        super(PoStateInitial());

  @override
  Stream<PoState> mapEventToState(PoEvent event, BuildContext context) async* {
    if (event is PoEventOpenAsiScanner) {
      yield* _scanAsi(event, context);
    } else if (event is PoEventOpenDocumentScanner) {
      yield* _scanDocumentNo(event, context);
    } else if (event is PoEventDiscardDocument) {
      yield PoStateDocumentDiscarded();
    } else if (event is PoEventLoadReceiptDocType) {
      yield* _loadReceiptDocType(event);
    } else if (event is PoEventLoadLocators) {
      yield* _loadLocators(event);
    } else if (event is PoEventLoadPurchaseOrderLines) {
      yield* _loadLines(event);
    } else if (event is PoEventSubmitReceipt) {
      yield* _submitDocument(event);
    } else if (event is PoEventUpdateLines) {
      yield PoStateReceiptLinesUpdate(lines: event.receiptLine);
    }
  }

  Stream<PoState> _scanDocumentNo(
      PoEventOpenDocumentScanner event, BuildContext context) async* {
    // Scan barcode menggunakan context yang diteruskan
    final documentNo =
        await scanBarcode(context); // Ganti dengan scanBarcode(context)

    _logger.i('Got document no.: $documentNo');

    // Periksa jika pemindaian dibatalkan
    if (documentNo == null || documentNo == 'Cancelled') {
      yield PoStateScanCanceled();
    } else {
      // Lanjutkan dengan nomor dokumen yang dipindai
      yield PoStateDocumentNoScanned(documentNo: documentNo);

      yield PoStateLoading();
      final data = await _poUseCase.getRecord(documentNo: documentNo);

      yield data.fold(
        (err) {
          String? message;

          // Menangani error berdasarkan jenisnya
          if (err is ClientError) {
            message = err.message;
          } else if (err is ServerError) {
            message = err.message;
          } else if (err is UnknownError) {
            message = err.message;
          }

          _logger.e('Failed getting PO document. $message');
          return PoStateFailed(message: message!);
        },
        (po) => PoStateDocumentLoaded(data: po),
      );
    }
  }

  Stream<PoState> _scanAsi(
      PoEventOpenAsiScanner event, BuildContext context) async* {
    final scanMode = event.scanMode;

    // Menggunakan scanBarcode yang baru dengan context
    final attributeNo = await scanBarcode(context);

    if (attributeNo == null || attributeNo == 'Cancelled') {
      yield PoStateScanCanceled();
    } else {
      yield* _processAsi(
        scanMode: scanMode,
        line: event.line,
        attributeNo: attributeNo,
        scannedAttributeSets: event.scannedAttributeSets,
      );
    }
  }

  Stream<PoState> _loadReceiptDocType(PoEventLoadReceiptDocType event) async* {
    yield PoStateLoading();
    final data = await _receiptUseCase.getDocTypeId(event.poDocTypeId);
    dynamic result = data.fold((err) {
      String? message;

      if (err is ServerError) {
        message = err.message;
      } else if (err is NoConnectionError) {
        message = err.message;
      }

      _logger.e('Failed getting receipt docType ID. $message');
      return message;
    }, (id) => id);

    if (result is int) {
      yield PoStateReceiptDocTypeLoaded(id: result);
    } else {
      yield PoStateFailed(message: result);
    }
  }

  Stream<PoState> _loadLocators(PoEventLoadLocators event) async* {
    yield PoStateLoading();
    final data = await _poUseCase.getLocators(warehouseId: event.warehouseId);
    dynamic result = data.fold((err) {
      String? message;

      if (err is ServerError) {
        message = err.message;
      } else if (err is NoConnectionError) {
        message = err.message;
      }

      _logger.e('Failed getting locators. $message');
      return message;
    }, (locators) => locators);

    if (result is List<LocatorEntity>) {
      yield PoStateLocatorsLoaded(locators: result);
    } else {
      yield PoStateFailed(message: result);
    }
  }

  Stream<PoState> _loadLines(PoEventLoadPurchaseOrderLines event) async* {
    yield PoStateLoading();
    final data = await _receiptUseCase.createLines(
        po: event.po, locatorId: event.locatorId);

    yield data.fold((err) {
      String? message;

      if (err is ClientError) {
        message = err.message;
      } else if (err is ServerError) {
        message = err.message;
      } else if (err is UnknownError) {
        message = err.message;
      }

      _logger.e('Failed getting order lines. $message');
      return PoStateFailed(message: message!);
    }, (lines) {
      if (lines.length == 0) {
        return PoStateLineEmpty();
      }

      return PoStateReceiptLinesCreated(
        po: event.po,
        locatorId: event.locatorId,
        lines: lines,
      );
    });
  }

  Stream<PoState> _processAsi({
    String? scanMode,
    ReceiptLineEntity? line,
    String? attributeNo,
    Map<String, ReceiptLineEntity>? scannedAttributeSets,
  }) async* {
    // Early return if any of the required arguments are null
    if (scanMode == null ||
        line == null ||
        attributeNo == null ||
        scannedAttributeSets == null) {
      yield PoStateFailed(message: 'Missing required parameters.');
      return;
    }

    // Allow a product to be scanned multiple times for the same line.
    if (scannedAttributeSets.containsKey(line.attributeNo)) {
      scannedAttributeSets.remove(line.attributeNo);
    }

    final isAsiAlreadyUsed = scannedAttributeSets.containsKey(attributeNo);

    _logger
        .i('Got attribute no.: $attributeNo, already used: $isAsiAlreadyUsed');
    if (isAsiAlreadyUsed) {
      yield PoStateSerialNoDuplication();
    } else {
      yield PoStateLoading();
      final product = await _getProduct(scanMode, line, attributeNo);
      final storageData = product.fold((error) => error, (product) => product);

      // Create new ASI if no existing ASI is found
      if (storageData == null) {
        _logger.i('Creating a new attribute set instance');
        final asi = await _createAsi(
          attributeSetId: line.attributeSet!.id,
          lot: scanMode == 'lot' ? attributeNo : null,
          serNo: scanMode == 'serNo' ? attributeNo : null,
        );

        if (asi == null) {
          yield PoStateFailed(message: 'Failed when applying the ASI number');
        } else {
          line.attributeSetInstance =
              ReferenceModel(id: asi.id, identifier: asi.description);

          if (line.isSerNo!) {
            line
              ..attributeNo = attributeNo
              ..selected = true;

            scannedAttributeSets.putIfAbsent(attributeNo, () => line);
          }

          yield PoStateAsiScanned(line: line);
        }
      }
      // Get the existing ASI ID
      else if (storageData is StorageEntity) {
        line.attributeSetInstance = storageData.asi;
        yield PoStateAsiScanned(line: line);
      } else {
        yield PoStateFailed(message: storageData.toString());
      }
    }
  }

  Stream<PoState> _submitDocument(PoEventSubmitReceipt event) async* {
    yield PoStateLoading();
    _logger.d('Submitting PO receipt...');
    final receipt = event.receipt;
    String json = jsonEncode((receipt as ReceiptModel).toJson());
    _logger.v('Receipt: $json');

    // Apply locators to all receipt lines.
    final selectedLines = List<ReceiptLineEntity>.from(
        event.lines.where((line) => line.selected!));

    selectedLines
      ..forEach((line) {
        String lineJson = jsonEncode(line.toJson());
        _logger.v('- Line: $lineJson');
        line.line = 0;
        line.locator = ReferenceModel(id: event.locatorId);
      });
    _logger.v('Receipt: $selectedLines');
    receipt.lines = selectedLines;

    final data = await _receiptUseCase.submit(receipt);
    dynamic result = data.fold((err) {
      String? message;

      if (err is ServerError) {
        message = err.message;
      } else if (err is NoConnectionError) {
        message = err.message;
      } else if (err is UnknownError) {
        message = err.message;
      }

      _logger.e('Failed submitting the document. $message');
      return message;
    }, (createdDoc) => createdDoc);

    if (result is ReceiptEntity) {
      yield PoStateReceiptCreated(receipt: result);
    } else {
      yield PoStateFailed(message: result);
    }
  }

  Future<Either<String, StorageEntity>> _getProduct(
      String scanMode, ReceiptLineEntity line, String attributeNo) async {
    final data = await _attributeSetUseCase.getExistingInstances(
        line.product!.id,
        lot: scanMode == 'lot' ? attributeNo : null,
        serNo: scanMode == 'serNo' ? attributeNo : null);

    return data.fold((err) {
      String message;
      if (err is ServerError) {
        message = err.message;
      } else {
        message = err.toString();
      }

      _logger.e(message);
      return Left(message);
    }, (storage) => Right(storage as StorageEntity));
  }

  Future<AttributeSetInstance> _createAsi({
    int? attributeSetId,
    String? lot,
    String? serNo,
  }) async {
    // Check if either `lot` or `serNo` is null, as one must be provided
    if (lot == null && serNo == null) {
      throw ArgumentError(
          'At least one of `lot` or `serialNo` must be provided.');
    }

    // Create the AttributeSetInstanceModel
    final data = AttributeSetInstanceModel(
      attributeSet: ReferenceModel(id: attributeSetId),
      lot: lot!, // No need to force unwrap, it can be null
      serialNo: serNo!, // No need to force unwrap, it can be null
      description: serNo == null ? '#$lot' : '#$serNo',
    );

    // Create the ASI instance and handle the result
    final entity = await _attributeSetUseCase.createInstance(data);

    return entity.fold(
      (err) {
        // Handle error gracefully, could log the error or return a default value
        _logger.e('Error creating ASI: $err');
        throw Exception(
            'Failed to create ASI: $err'); // Or return a default value or error state
      },
      (asi) {
        // Return the created ASI instance
        return asi;
      },
    );
  }
}
