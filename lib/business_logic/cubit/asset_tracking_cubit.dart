import 'dart:convert';

import 'package:apps_mobile/business_logic/models/assettrackingloc_model.dart';
import 'package:apps_mobile/business_logic/models/assettrackingstatus_model.dart';
import 'package:apps_mobile/business_logic/models/image_equipment.dart';
import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/business_logic/models/installbasestatus.dart';
import 'package:apps_mobile/business_logic/models/installbasetrf.dart';
import 'package:apps_mobile/business_logic/models/pmbacklog.dart';
import 'package:apps_mobile/services/assettracking/asset_tracking_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../service_locator.dart';
import '../utils/logger.dart';

part 'asset_tracking_state.dart';

class AssetTrackingCubit extends Cubit<AssetTrackingState> {
  final log = getLogger('AssetTrackingCubit');
  AssetTrackingCubit() : super(AssetTrackingInitial());

  Future<void> getLocation() async {
    print('getLocation_Cubit');
    try {
      List<AssetTrackingLocation> loadLocation =
          await sl<AssetTrackingService>().getAssetTrackingLocation();
      List<AssetTrackingStatus> loadStatus =
          await sl<AssetTrackingService>().getAssetTrackingStatus();

      emit(AssetTrackingLoadInitial(loc: loadLocation, status: loadStatus));
    } catch (e) {
      log.e('load location error: $e');
      emit(AssetTrackingStateFailure(message: 'Failed to get location'));
    }
  }

  Future<void> getListDataAsset(String sn, status, location) async {
    print('getList');
    try {
      emit(AssetTrackigInProgress());
      List<InstallBaseModel> loadInstallBase = await sl<AssetTrackingService>()
          .getListDataAsset(sn, status, location);

      emit(AssetTrackingLoadInstallBase(installBase: loadInstallBase));
    } catch (e) {
      log.e('load location error: $e');
      emit(AssetTrackingStateFailure(message: 'Failed to get list data'));
    }
  }

  Future<void> getphoto(int assetID) async {
    print('getPhoto, assetID = $assetID');
    try {
      emit(AssetTrackigInProgress());
      var photo = await sl<AssetTrackingService>().getphoto(assetID);
      Base64Codec base64 = Base64Codec();
      var decodephoto = photo == "null" ? null : base64.decode(photo);
      var statushistory = await getInstallBaseStatus(assetID);
      var trfhistory = await getInstallBaseTransferHistory(assetID);

      emit(AssetTrackingLoadDetail(
          photo: decodephoto,
          statushistory: statushistory!,
          trfhistory: trfhistory!));
    } catch (e) {
      log.e('error get photo: $e');
      emit(AssetTrackingStateFailure(message: 'Failed to get photo'));
    }
  }

  Future<List<InstallBaseStatus>?> getInstallBaseStatus(int assetID) async {
    print('getInstallBaseStatus, assetID = $assetID');
    try {
      List<InstallBaseStatus> loadStatusHistory =
          await sl<AssetTrackingService>().getInstallBaseStatusHistory(assetID);
      return loadStatusHistory;
    } catch (e) {
      log.e('error get installbasestatus: $e');
      emit(AssetTrackingStateFailure(message: 'Failed to get Status History '));
    }
    return null;
  }

  Future<List<InstallBaseTransfer>?> getInstallBaseTransferHistory(
      int assetID) async {
    print('getInstallBaseTransfer, assetID = $assetID');
    try {
      List<InstallBaseTransfer> loadStatusHistory =
          await sl<AssetTrackingService>()
              .getInstallBaseTransferHistory(assetID);
      return loadStatusHistory;
    } catch (e) {
      log.e('error get InstallBaseTransfer: $e');
      emit(AssetTrackingStateFailure(message: 'Failed to get trf history '));
    }
    return null;
  }

  Future<void> getPMBacklog(int equipmentid) async {
    log.i('getPMBacklog');
    try {
      emit(AssetTrackigInProgress());
      List<PMBacklogModel> pmbacklog =
          await sl<AssetTrackingService>().getPMBaclock(equipmentid);
      emit(PMBacklogSuccess(pmbacklog: pmbacklog));
    } catch (e) {
      log.e('getPMBacklog $e');
      emit(PMBacklogFailure(message: e.toString()));
    }
  }

  Future<void> getImageEquipment(int equipmentid) async {
    log.i('getImageEquipment');
    try {
      emit(AssetTrackigInProgress());
      List<ImageEquipment> imageequipment =
          await sl<AssetTrackingService>().getImageEquipment(equipmentid);
      emit(ImageEquipmentSuccess(imageequipment: imageequipment));
    } catch (e) {
      log.e('getImageEquipment $e');
      emit(PMBacklogFailure(message: e.toString()));
    }
  }
}
