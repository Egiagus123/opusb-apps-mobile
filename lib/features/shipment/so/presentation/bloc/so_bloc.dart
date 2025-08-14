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
import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_model.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/usecase/shipment_usecase.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/usecase/so_usecase.dart';

import './bloc.dart';

class SoBloc extends Bloc<SoEvent, SoState> {
  final _logger = Logger();
  final SoUseCase _poUseCase;
  final ShipmentUseCase _shipmentUseCase;
  final AttributeSetUseCase _attributeSetUseCase;

  SoBloc(
      {@required AttributeSetUseCase? attributeSetUseCase,
      @required SoUseCase? poUseCase,
      @required ShipmentUseCase? shipmentUseCase})
      : _attributeSetUseCase = attributeSetUseCase!,
        _poUseCase = poUseCase!,
        _shipmentUseCase = shipmentUseCase!,
        super(SoStateInitial());

  // @override
  // SoState get initialState => SoStateInitial();

  @override
  Stream<SoState> mapEventToState(SoEvent event, BuildContext context) async* {
    if (event is SoEventOpenAsiScanner) {
      yield* _scanAsi(event, context);
    } else if (event is SoEventOpenDocumentScanner) {
      yield* _scanDocumentNo(event, context);
    } else if (event is SoEventDiscardDocument) {
      yield SoStateDocumentDiscarded();
    }

    if (event is SoEventLoadShipmentDocType) {
      yield* _loadShipmentDocType(event);
    }

    if (event is SoEventLoadLocators) {
      yield* _loadLocators(event);
    } else if (event is SoEventLoadOrderLines) {
      yield* _loadLines(event);
    } else if (event is SoEventSubmitShipment) {
      yield* _submitDocument(event);
    }
    if (event is SoEventUpdateLines) {
      yield* _updateLines(event);
    }
  }

  Stream<SoState> _scanDocumentNo(
      SoEventOpenDocumentScanner event, BuildContext context) async* {
    // Menggunakan scanBarcode(context) untuk pemindaian barcode
    final documentNo = await scanBarcode(context);

    _logger.i('Got document no.: $documentNo');

    // Mengecek apakah pemindaian dibatalkan
    if (documentNo == 'Cancelled' || documentNo == null) {
      yield SoStateScanCanceled();
    } else {
      yield SoStateDocumentNoScanned(documentNo: documentNo);
      yield SoStateLoading();

      // Mendapatkan data dengan documentNo yang telah dipindai
      final data = await _poUseCase.getRecord(documentNo: documentNo);

      // Menangani hasil data yang didapat
      yield data.fold(
        (err) {
          final message = _parseError(err);
          _logger.e('Failed getting PO document. $message');
          return SoStateFailed(message: message);
        },
        (po) => SoStateDocumentLoaded(data: po),
      );
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

  Stream<SoState> _scanAsi(
      SoEventOpenAsiScanner event, BuildContext context) async* {
    final scanMode = event.scanMode;

    // Menggunakan scanBarcode(context) untuk pemindaian barcode
    final attributeNo = await scanBarcode(context);

    // Mengecek jika pemindaian dibatalkan
    if (attributeNo == 'Cancelled' || attributeNo == null) {
      yield SoStateScanCanceled();
    } else {
      yield* _processAsi(
        scanMode: scanMode,
        line: event.line,
        attributeNo: attributeNo, // Menggunakan attributeNo yang dipindai
        scannedAttributeSets: event.scannedAttributeSets,
      );
    }
  }

  Stream<SoState> _loadShipmentDocType(
      SoEventLoadShipmentDocType event) async* {
    yield SoStateLoading();
    final data = await _shipmentUseCase.getDocTypeId(event.poDocTypeId);
    dynamic result = data.fold((err) {
      String? message;

      if (err is ServerError) {
        message = err.message;
      } else if (err is NoConnectionError) {
        message = err.message;
      }

      _logger.e('Failed getting receupt docType ID. ${message}');
      return message;
    }, (id) => id);

    if (result is int) {
      yield SoStateShipmentDocTypeLoaded(id: result);
    } else {
      yield SoStateFailed(message: result);
    }
  }

  Stream<SoState> _loadLocators(SoEventLoadLocators event) async* {
    yield SoStateLoading();
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
      yield SoStateLocatorsLoaded(locators: result);
    } else {
      yield SoStateFailed(message: result);
    }
  }

  Stream<SoState> _loadLines(SoEventLoadOrderLines event) async* {
    yield SoStateLoading();
    final data = await _shipmentUseCase.createLines(
        so: event.so, locatorId: event.locatorId);

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
      return SoStateFailed(message: message!);
    }, (lines) {
      if (lines.length == 0) {
        return SoStateLineEmpty();
      }

      return SoStateShipmentLinesCreated(
        so: event.so,
        locatorId: event.locatorId,
        lines: lines,
      );
    });
  }

  Stream<SoState> _processAsi(
      {String? scanMode,
      ShipmentLineEntity? line,
      String? attributeNo,
      Map<String, ShipmentLineEntity>? scannedAttributeSets}) async* {
    // Allow a product to be scanned multiple times for the same line.
    if (scannedAttributeSets!.containsKey(line!.attributeNo)) {
      scannedAttributeSets.remove(line.attributeNo);
    }

    final isAsiAlreadyUsed = scannedAttributeSets.containsKey(attributeNo);

    _logger.i('Got attribute no.: $attributeNo, exists: $isAsiAlreadyUsed');
    if (isAsiAlreadyUsed) {
      yield SoStateSerialNoDuplication();
    } else {
      yield SoStateLoading();
      final product = await _getProduct(scanMode!, line, attributeNo!);
      yield product.fold((error) => SoStateFailed(message: error), (product) {
        // Get the existing ASI id.
        if (product is StorageEntity) {
          _logger.i(
              'Product with the same lot/serial no. is found in the storage');
          line.attributeSetInstance = product.asi;

          if (line.isSerNo!) {
            line
              ..attributeNo = attributeNo
              ..selected = true;

            scannedAttributeSets.putIfAbsent(attributeNo, () => line);
          }

          return SoStateAsiScanned(line: line);
        } else {
          _logger.e('Lot/serial no. doesn\'t exist');
          return SoStateFailed(message: 'Product is not available');
        }
      });
    }
  }

  Stream<SoState> _submitDocument(SoEventSubmitShipment event) async* {
    yield SoStateLoading();
    _logger.d('Submitting SO shipment...');
    final shipment = event.shipment;
    String json = jsonEncode((shipment as ShipmentModel).toJson());
    _logger.v('Shipment: $json');

    final selectedLines = List<ShipmentLineEntity>.from(
        event.lines.where((line) => line.selected!));

    selectedLines
      ..forEach((line) {
        String lineJson = jsonEncode(line.toJson());
        _logger.v('- Line: $lineJson');
        line.line = 0;
        line.locator = ReferenceModel(id: event.locatorId);
      });

    shipment.lines = selectedLines;

    final data = await _shipmentUseCase.submit(shipment);
    yield data.fold((err) {
      String? message;

      if (err is ServerError) {
        message = err.message;
      } else if (err is NoConnectionError) {
        message = err.message;
      } else if (err is UnknownError) {
        message = err.message;
      }

      _logger.e('Failed submitting SO shipment document. $message');
      return SoStateFailed(message: message!);
    }, (createdDoc) => SoStateShipmentCreated(shipment: createdDoc));
  }

  Stream<SoState> _updateLines(SoEventUpdateLines event) async* {
    yield SoStateShipmentLinesUpdate(lines: event.shipmentLine);
  }

  Future<Either<String, StorageEntity>> _getProduct(
      String scanMode, ShipmentLineEntity line, String attributeNo) async {
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
    }, (list) => Right(list!.firstOrNull!));
  }
}
