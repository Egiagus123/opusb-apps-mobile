import 'package:apps_mobile/business_logic/models/assettrfmodel/tooltrf_header.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/services/offlineservices/offline_service.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/table_trxasset.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service_locator.dart';
part 'asset_offline_state.dart';

class AssetOfflineCubit extends Cubit<AssetOfflineState> {
  AssetOfflineCubit() : super(AssetOfflineInitial());
  DatabaseHelper helper = DatabaseHelper();
  QueryTrxTable query = QueryTrxTable();
  final log = getLogger('AssetTransferReceivingCubit');

  Future<void> pushDataOffline(ToolsTrfHeader dataHeader) async {
    print('pushDataOfflineCubit');
    try {
      final ToolsTrfHeader processrespose =
          await sl<OfflineService>().pushTrxAsset(dataHeader);

      emit(AssetOfflinePushSubmitted(data: processrespose));
    } catch (e) {
      log.e('Failed to submitted: $e');
      emit(AssetOfflinePushSubmittedFailure(message: e.toString()));
    }
  }
}
