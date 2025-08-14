import 'package:apps_mobile/business_logic/models/assetrcvmodel/assetrcvdata_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrf.dart';
import 'package:apps_mobile/business_logic/models/installbasestatus.dart';
import 'package:apps_mobile/business_logic/models/installbasetrf.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/assettrf/asset_trf_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
part 'asset_trfrcv_state.dart';

class AssetTransferReceivingCubit extends Cubit<AssetTransferReceivingState> {
  final log = getLogger('AssetTransferReceivingCubit');
  AssetTransferReceivingCubit() : super(AssetTransferInitial());

  Future<void> getData() async {
    print('getDataCubit');
    try {
      emit(AssetTransferReceivingInProgress());
      List<AssetRequestModel> assetRequest =
          await sl<AssetTransferService>().getAssetRequest();

      emit(AssetTransferLoadDataHeader(assetRequest: assetRequest));
    } catch (e) {
      log.e('load location error: $e');
      emit(AssetTransferReceivingStateFailure(
          message: 'Failed to get location'));
    }
  }

  Future<void> getDataLine(idHeader) async {
    print('getDataLine');
    try {
      emit(AssetTransferReceivingInProgress());
      List<AssetRequestLine> loadLine =
          await sl<AssetTransferService>().getAssetTransferLine(idHeader);

      emit(AssetTransferLoadDataLine(line: loadLine));
    } catch (e) {
      log.e('load location error: $e');
      emit(AssetTransferReceivingStateFailure(
          message: 'Failed to get location'));
    }
  }

  Future<List<AssetRequestLine>> getSerno(int id,
      List<AssetRequestLine> assetRequestLine, BuildContext context) async {
    print('getSernoLine');

// Pindai barcode untuk mendapatkan serno
    final serno = await scanBarcode(context);

    if (serno == null || serno.isEmpty) {
      // Emit jika scan dibatalkan atau hasil kosong
      emit(AssetTransferScanCancel());
      return assetRequestLine; // Kembalikan assetRequestLine yang ada
    } else {
      try {
        // Mendapatkan data berdasarkan serno dan id
        var line = await sl<AssetTransferService>()
            .getAssetTransferLinebySerno(serno, id);

        if (line.isNotEmpty) {
          // Mengecek apakah data sudah ada di assetRequestLine
          if (assetRequestLine.every((i) => i.id != line[0].id)) {
            assetRequestLine.addAll(line); // Menambahkan data baru
            return assetRequestLine; // Kembalikan list yang sudah ditambah
          } else {
            emit(AssetNotFound(message: 'Already added!'));
          }
        } else {
          emit(AssetNotFound(message: 'Data is not found!'));
        }
      } catch (e) {
        // Menangani error yang terjadi
        emit(AssetNotFound(message: 'Error: ${e.toString()}'));
      }
    }
    return assetRequestLine; // Kembalikan assetRequestLine yang ada jika tidak ada perubahan
  }

  Future<void> pushData(GenerateData data, String tablename) async {
    print('getDataCubit');
    try {
      final GenerateData processrespose =
          await sl<AssetTransferService>().pushData(data, tablename);

      emit(AssetTransferReceivingSubmitted(data: processrespose));
    } catch (e) {
      log.e('Failed to submitted: $e');
      emit(AssetTransferReceivingStateFailure(message: e.toString()));
    }
  }

  Future<List<AssetRcvData>> getLocation(BuildContext context) async {
    print('getLocation_Cubit');

    // Memindai barcode untuk mendapatkan locID
    final locID = await scanBarcode(context);

    if (locID == null || locID == 'Cancelled') {
      // Emit jika scan dibatalkan
      emit(AssetTransferScanCancel());
      return []; // Kembalikan list kosong jika dibatalkan
    } else {
      try {
        // Mengambil data berdasarkan locID yang telah dipindai
        var locatorTo = await sl<AssetTransferService>()
            .getAssetDataRcvLocation(int.parse(locID));

        if (locatorTo.isNotEmpty) {
          return locatorTo; // Kembalikan data jika ditemukan
        } else {
          emit(AssetNotFound(message: 'Location is not found!'));
          return []; // Kembalikan list kosong jika tidak ditemukan
        }
      } catch (e) {
        // Tangani jika terjadi error
        emit(AssetNotFound(message: 'Error: ${e.toString()}'));
        return []; // Kembalikan list kosong jika terjadi kesalahan
      }
    }
  }

  Future<List<AssetRcvData>> getLinesRcv(int locID, String serno) async {
    print('getLocation_Cubit');

    try {
      var lines =
          await sl<AssetTransferService>().getAssetDataRcvLines(locID, serno);

      if (lines.isNotEmpty) {
        return lines;
      } else {
        // Emit error jika data tidak ditemukan
        emit(AssetNotFound(message: 'Location is not found!'));
        return []; // Mengembalikan list kosong jika data tidak ditemukan
      }
    } catch (e) {
      // Tangani error yang mungkin terjadi pada saat pengambilan data
      emit(AssetNotFound(message: 'Failed to load data: ${e.toString()}'));
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }
}
