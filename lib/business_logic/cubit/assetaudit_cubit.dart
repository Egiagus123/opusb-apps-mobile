import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditline.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetmodels.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/services/assetaudit/asset_audit_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../service_locator.dart';
import '../utils/logger.dart';
import 'package:equatable/equatable.dart';

part 'assetaudit_state.dart';

class AssetAuditCubit extends Cubit<AssetAuditState> {
  final log = getLogger('AssetAuditCubit');
  AssetAuditCubit() : super(AssetAuditInitialBLOC());

  Future<void> getAssetAuditHeader(String docNo) async {
    try {
      emit(AssetAuditInProgress());
      List<AssetAuditHeader> dataHeader =
          await sl<AssetAuditService>().getAssetAuditHeader(docNo);
      if (dataHeader.isNotEmpty) {
        emit(AssetAuditLoadHeader(dataHeader: dataHeader));
      } else {
        emit(AssetAuditFailed(message: 'Document No. $docNo is not found.'));
      }
    } catch (e) {
      log.e('load header data error: $e');
      emit(AssetAuditFailed(message: e.toString()));
    }
  }

  Future<void> getLinesAudited(int idHeader) async {
    try {
      emit(AssetAuditInProgress());
      List<AssetAuditLines> dataHeader =
          await sl<AssetAuditService>().getLinesAudited(idHeader);
      if (dataHeader.isNotEmpty) {
        emit(AssetAuditGetLinesAudited(dataLines: dataHeader));
      } else {
        emit(AssetAuditLoadFailed(message: 'Asset not found.'));
      }
    } catch (e) {
      log.e('load data error: $e');
      emit(AssetAuditFailed(message: e.toString()));
    }
  }

  // Future<void> getLineByCardTap(int idHeader, assetID) async {
  //   try {
  //     emit(AssetAuditInProgress());
  //     List<AssetAuditLines> dataLines =
  //         await sl<AssetAuditService>().getAssetAuditLines(idHeader, assetID);
  //     if (dataLines != null) {
  //       emit(ChangePage());
  //       List<AssetAuditStatusModel> auditStatus = await getAssetAuditStatus();

  //       emit(AssetAuditLoadLineAndGetAuditStatus(
  //           dataLines: dataLines, auditStatus: auditStatus));
  //     } else {
  //       List<AssetModel> checkisAssetAvailable =
  //           await sl<AssetAuditService>().isAssetAvailable(assetID);
  //       if (checkisAssetAvailable.isNotEmpty) {
  //         List<AssetAuditStatusModel> auditStatus = await getAssetAuditStatus();
  //         emit(AssetAuditCreateLineAndGetAuditStatus(
  //           newLines: checkisAssetAvailable,
  //           auditStatus: auditStatus,
  //         ));
  //       }
  //     }
  //   } catch (e) {
  //     log.e('load getLineByCardTap error: $e');
  //     emit(AssetAuditFailed(message: e.toString()));
  //   }
  // }

  Future<void> scanLinesbyQR(int idHeader, BuildContext context) async {
    // Pindai barcode untuk mendapatkan assetSearchKey
    final scan = await scanBarcode(context);

    // Jika pemindaian dibatalkan
    if (scan == null || scan == 'Cancelled') {
      emit(AssetAuditScanCancel());
    } else {
      var assetSearchKey = scan;

      // Pastikan assetSearchKey tidak kosong
      if (assetSearchKey.isEmpty) {
        emit(AssetAuditFailed(message: 'Invalid barcode or empty scan.'));
        return; // Menghentikan eksekusi jika hasil pemindaian kosong
      }

      try {
        // Menandakan bahwa proses sedang berlangsung
        emit(AssetAuditInProgress());

        // Mendapatkan data audit lines
        List<AssetAuditLines> dataLines = await sl<AssetAuditService>()
            .getAssetAuditLines(idHeader, assetSearchKey);

        if (dataLines.isNotEmpty) {
          // Jika ada data audit lines, lanjutkan proses
          emit(ChangePage());

          // Mendapatkan status audit
          List<AssetAuditStatusModel> auditStatus = await getAssetAuditStatus();

          emit(AssetAuditLoadLineAndGetAuditStatus(
              dataLines: dataLines, auditStatus: auditStatus));
        } else {
          // Jika tidak ada data audit lines, periksa apakah asset tersedia
          List<AssetModel> checkisAssetAvailable =
              await sl<AssetAuditService>().isAssetAvailable(assetSearchKey);

          if (checkisAssetAvailable.isNotEmpty) {
            // Jika asset ditemukan, buatkan line baru dan ambil status audit
            List<AssetAuditStatusModel> auditStatus =
                await getAssetAuditStatus();
            emit(AssetAuditCreateLineAndGetAuditStatus(
              newLines: checkisAssetAvailable,
              auditStatus: auditStatus,
            ));
          } else {
            emit(AssetAuditFailed(message: 'Asset not found.'));
          }
        }
      } catch (e) {
        // Menangani error jika terjadi
        log.e('Error loading header data: $e');
        emit(AssetAuditFailed(message: 'Error: ${e.toString()}'));
      }
    }
  }

  Future<void> getLinesByKeyboardInput(int idHeader, var assetSearchKey) async {
    try {
      emit(AssetAuditInProgress());
      List<AssetAuditLines> dataLines = await sl<AssetAuditService>()
          .getAssetAuditLines(idHeader, assetSearchKey);
      if (dataLines != null) {
        emit(ChangePage());
        List<AssetAuditStatusModel> auditStatus = await getAssetAuditStatus();

        emit(AssetAuditLoadLineAndGetAuditStatus(
            dataLines: dataLines, auditStatus: auditStatus));
      } else {
        List<AssetModel> checkisAssetAvailable =
            await sl<AssetAuditService>().isAssetAvailable(assetSearchKey);
        if (checkisAssetAvailable.isNotEmpty) {
          List<AssetAuditStatusModel> auditStatus = await getAssetAuditStatus();
          emit(AssetAuditCreateLineAndGetAuditStatus(
            newLines: checkisAssetAvailable,
            auditStatus: auditStatus,
          ));
        }
      }
    } catch (e) {
      log.e('load header data error: $e');
      emit(AssetAuditFailed(message: e.toString()));
    }
  }

  Future<List<AssetAuditStatusModel>> getAssetAuditStatus() async {
    List<AssetAuditStatusModel> assetAuditListStatus =
        []; // Inisialisasi dengan list kosong
    try {
      emit(AssetAuditInProgress()); // Emit status progress
      assetAuditListStatus =
          await sl<AssetAuditService>().getAssetAuditStatus();
      // emit(AssetAuditSuccess()); // Emit jika sukses
    } catch (e) {
      log.e('load header data error: $e');
      emit(AssetAuditFailed(message: e.toString())); // Emit error jika gagal
    }
    return assetAuditListStatus; // Pastikan list dikembalikan meskipun terjadi error
  }

  Future<bool> deleteLines(AssetAuditLines id) async {
    bool isDelete = false; // Inisialisasi dengan nilai default false
    try {
      emit(AssetAuditInProgress()); // Emit status progress
      isDelete = await sl<AssetAuditService>().deleteLine(id);
      if (isDelete) {
        emit(AssetAuditDeleteSuccess(
            deleteSuccess: isDelete)); // Emit success jika berhasil delete
      }
    } catch (e) {
      emit(AssetAuditFailed(message: e.toString())); // Emit error jika gagal
    }
    return isDelete; // Mengembalikan nilai isDelete (true/false)
  }

  Future<bool> updateLine(AssetAuditPut lines, int lineID) async {
    bool updateLine = false; // Inisialisasi dengan nilai default false
    try {
      emit(AssetAuditInProgress()); // Emit status progress
      updateLine = await sl<AssetAuditService>().mergeLine(lines, lineID);
      // if (updateLine) {
      //   emit(AssetAuditUpdateSuccess()); // Emit success jika update berhasil
      // }
    } catch (e) {
      emit(AssetAuditFailed(message: e.toString())); // Emit error jika gagal
    }
    return updateLine; // Mengembalikan nilai updateLine (true/false)
  }

  Future<bool> updateStatus(List<AssetAuditLines> lines, changedValue) async {
    if (lines.isEmpty) {
      return false; // Return false if the list is empty or null
    }

    // Update each line in the list
    lines.forEach((e) {
      e.auditStatus = changedValue;
    });

    return true; // Return true after successful update
  }

  // Method to create a new line
  Future<bool> createNew(AssetAuditPut lines, int headerID) async {
    bool createNew = false; // Initialize to false in case the try block fails
    try {
      // Attempt to create a new line
      createNew = await sl<AssetAuditService>().createNew(lines, headerID);
    } catch (e) {
      // If an error occurs, emit a failure state and return false
      emit(AssetAuditFailed(message: 'Failed to Create New Line'));
      return false;
    }
    // Return the result from the try block if successful
    return createNew;
  }

// Method to scan a document using QR code
  Future<void> scanDocumentbyQR(BuildContext context) async {
    try {
      // Pindai barcode untuk mendapatkan hasil scan
      final scan = await scanBarcode(context);

      // Jika pemindaian dibatalkan
      if (scan == null || scan == 'Cancelled') {
        emit(ScanCancel()); // Emit event pemindaian dibatalkan
      } else {
        emit(ScanValue(value: scan)); // Emit event dengan hasil scan
      }
    } catch (e) {
      // Menangani jika terjadi error saat pemindaian
      // emit(ScanError(message: 'Failed to scan document.')); // Emit event error
    }
  }
}
