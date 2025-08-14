import 'package:apps_mobile/business_logic/models/assetrcvmodel/assetrcvdata_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/business_logic/models/news.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/downloaddata/downloaddata_service.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/table_assetrcv.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/tablemovementreq_header.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/tablemovementreq_line.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_asset_rcv.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_header.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_line.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'downloaddata_state.dart';

class DownloadDataCubit extends Cubit<DownloadDataState> {
  final log = getLogger('DownloadDataCubit');
  DownloadDataCubit() : super(DownloadDataInitial());

  // Declaring the local variables
  late ListDataMovReqHeader listHeaderLocal;
  late ListDataMovReqLine listLineLocal;
  late ListDataGetReceiving listReceiving;

  Future<void> getData() async {
    print('getDataCubit');
    final helper = QueryTableHeader();
    final helperln = QueryTableLine();
    List<ListDataMovReqHeader> list = [];

    try {
      emit(DownloadinProgress());

      // Fetch asset request
      List<AssetRequestModel> assetRequest =
          await sl<DownloadDataService>().getAssetRequest();
      await helperln.deleteAllData();

      for (var e in assetRequest) {
        var datetrf = DateFormat('MM/dd/yyyy').format(e.dateRequired);

        listHeaderLocal = ListDataMovReqHeader(
          e.client.id,
          e.org.id,
          e.headerID.id,
          e.locator.id,
          e.locatorTo.id,
          e.documentNo,
          e.dateDoc,
          e.dateReceived,
          datetrf,
          e.locator.identifier!,
          e.locatorTo.identifier!,
        );

        list.add(listHeaderLocal);

        // Ensure to await asynchronous calls
        await getDataLine(e.headerID.id);
      }

      emit(SavingDataToLocal());

      await helper.deleteAllData();
      var saveHeader = await helper.insertDataTrx(list);

      // Get receiving data
      await getDataReceiving();

      emit(DownloadDataLoadData(
        saveline: saveHeader,
        assetRequestHeader: [],
        assetRequestLine: [],
      ));
    } catch (e) {
      log.e('load header data error: $e');
      emit(DownloadDataStateFailure(message: 'Failed to get header data'));
    }
  }

  Future<List<ListDataMovReqLine>> getDataLine(int idHeader) async {
    print('getDataLine');
    List<ListDataMovReqLine> dataline = [];
    final helper = QueryTableLine();
    List<ListDataMovReqLine> list = [];

    try {
      List<AssetRequestLine> loadLine =
          await sl<DownloadDataService>().getAssetTransferLine(idHeader);
      for (var e in loadLine) {
        listLineLocal = ListDataMovReqLine(
          e.client.id,
          e.org.id,
          e.id,
          e.toolReqID.id,
          e.installbase.id,
          e.installbase.identifier!,
          e.serNo,
          e.qtyDelivered,
          e.qtyEntered,
        );
        list.add(listLineLocal);
      }

      dataline = List.from(list);
      await helper.insertDataTrx(dataline);
    } catch (e) {
      log.e('load line error: $e');
      emit(DownloadDataStateFailure(message: 'Failed to get lines'));
    }
    return dataline;
  }

  Future<List<ListDataGetReceiving>> getDataReceiving() async {
    print('ListDataGetReceivingCubit');
    List<ListDataGetReceiving> dataGetReceiving = [];
    final helper = QueryGetAssetReceiving();
    List<ListDataGetReceiving> list = [];

    try {
      List<AssetRcvData> rcvData =
          await sl<DownloadDataService>().getAssetRcvData();
      for (var e in rcvData) {
        listReceiving = ListDataGetReceiving(
          e.client.id,
          e.org.id,
          e.requestLineID.id,
          e.id,
          e.installbase.id,
          e.installbase.identifier!,
          e.locatorTo.id,
          e.locatorTo.identifier!,
          'Receiving',
          e.serNo,
          e.qtyEntered,
          e.intransit,
          e.dateReceived,
          e.trfdatedoc,
          e.trfdocno,
        );
        list.add(listReceiving);
      }

      dataGetReceiving = List.from(list);
      await helper.deleteAllData();
      await helper.insertDataTrx(dataGetReceiving);
    } catch (e) {
      log.e('load receiving error: $e');
      emit(DownloadDataStateFailure(message: 'Failed to get receiving data'));
    }
    return dataGetReceiving;
  }
}
