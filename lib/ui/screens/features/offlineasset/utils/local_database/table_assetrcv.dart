import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_asset_rcv.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_line.dart';
import 'package:sqflite/sqflite.dart';

class TableGetAssetReceiving {
  //table_name
  static String tableReceiving = 'assetGetReceiving';

  //columns
  static String columnId = 'id';
  static String clientId = 'clientId';
  static String orgId = 'orgId';
  static String toolRequestLineID = 'toolRequestLineID';
  static String toolRequestId = 'toolRequestId';
  static String installBaseID = 'installBaseID';
  static String installBaseName = 'installBaseName';
  static String locatorNewID = 'locatorNewID';
  static String locationToName = 'locationToName';
  static String trxtype = 'trxtype';
  static String serNo = 'serNo';
  static String qtyEntered = 'qtyEntered';
  static String locatorIntransitID = 'locatorIntransitID';
  static String dateReceived = 'dateReceived';
  static String trfdatedoc = 'trfdatedoc';
  static String trfdocno = 'trfdocno';
}

class QueryGetAssetReceiving {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late TableGetAssetReceiving tableAssetRcv;

  //select
  Future<List<Map<String, dynamic>>> getDataList() async {
    Database db = await this.databaseHelper.database;
    var result = await db.query(TableGetAssetReceiving.tableReceiving);
    return result;
  }

  //convert to model
  Future<List<ListDataMovReqLine>> fetchdatalist() async {
    var mapList = await getDataList();
    int count = mapList.length;
    List<ListDataMovReqLine> prodList = [];

    for (int i = 0; i < count; i++) {
      prodList.add(ListDataMovReqLine.fromMapObject(mapList[i]));
    }
    print(count);

    return prodList;
  }

  //insert
  Future<int> insertDataTrx(List<ListDataGetReceiving> value) async {
    Database db = await this.databaseHelper.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      value.forEach((c) async {
        batch.insert(TableGetAssetReceiving.tableReceiving, c.toMap());
      });
      await batch.commit(noResult: true);
    });
    var mapList = await getDataList();
    int count = mapList.length;
    return count;
  }
  //update
  //delete

  Future<int> deleteAllData() async {
    Database db = await this.databaseHelper.database;
    var result = await db.delete(TableGetAssetReceiving.tableReceiving);
    return result;
  }

  Future<List<ListDataGetReceiving>> filterLocationFromDB(int locID) async {
    var loc = await searchFilterLoc(locID);
    List<ListDataGetReceiving> locList = [];

    locList.add(ListDataGetReceiving.fromMapObject(loc.first));

    return locList;
  }

  Future<List<dynamic>> searchFilterLoc(int locID) async {
    Database db = await this.databaseHelper.database;

    var result = await db.rawQuery(
        'select ${TableGetAssetReceiving.locationToName} from ${TableGetAssetReceiving.tableReceiving} where ${TableGetAssetReceiving.locatorNewID} = $locID');

    return result;
  }

  Future<List<ListDataGetReceiving>> filterSn(String sn, location) async {
    var loc = await searchFilterSn(sn, location);
    List<ListDataGetReceiving> assetRCV = [];

    assetRCV.add(ListDataGetReceiving.fromMapObject(loc.first));

    return assetRCV;
  }

  Future<List<dynamic>> searchFilterSn(String sn, location) async {
    Database db = await this.databaseHelper.database;

    // var result = await db.rawQuery(
    //     "select * from ${TableGetAssetReceiving.tableReceiving} where ${TableGetAssetReceiving.serNo} = '$sn' and ${TableGetAssetReceiving.locationToName} = '$location'");
    var result = await db.query(TableGetAssetReceiving.tableReceiving,
        where:
            "${TableGetAssetReceiving.serNo} ='$sn' and ${TableGetAssetReceiving.locationToName} = '$location' ");
    return result;
  }
}
