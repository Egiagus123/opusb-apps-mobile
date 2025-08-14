import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_assetline.dart';
import 'package:sqflite/sqflite.dart';

import '../localmodels/list_asset.dart';

class TableTrfHeader {
  //table_name
  static String tableAssetHeader = 'tableAssetHeader';

  //columns
  static String columnId = 'id';
  static String clientId = 'clientId';
  static String orgId = 'orgId';
  static String toolRequestID = 'toolRequestId';
  static String locatorID = 'locatorID';
  static String locatorNewID = 'locatorNewID';
  static String documentNo = 'docNo';
  static String dateDoc = 'dateDocument';
  static String dateReceived = 'dateReq';
  static String dateRequired = 'dateRec';
  static String locationfromName = 'locationfromName';
  static String locationToName = 'locationToName';
  static String trxtype = 'trxtype';
}

class TableTrfLine {
  //table_name
  static String tableAssetLine = 'tableAssetLine';

  //columns
  static String columnId = 'id';
  static String clientId = 'clientId';
  static String orgId = 'orgId';
  static String toolRequestLineID = 'toolRequestLineID';
  static String toolRequestID = 'toolRequestId';
  static String installBaseID = 'installBaseID';
  static String installBaseName = 'installBaseName';
  static String serNo = 'serNo';
  static String qtyDelivered = 'qtyDelivered';
  static String qtyEntered = 'qtyEntered';
}

class QueryTrxTable {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late TableTrfHeader tableAssetTrfLine;

  //select
  Future<List<Map<String, dynamic>>> getDataList() async {
    Database db = await this.databaseHelper.database;
    var result = await db.query(TableTrfHeader.tableAssetHeader);
    return result;
  }

  //convert to model
  Future<List<ListAssetTrf>> fetchdatalistHeader() async {
    var mapList = await getDataList();
    int count = mapList.length;
    List<ListAssetTrf> trxHeader = [];

    for (int i = 0; i < count; i++) {
      trxHeader.add(ListAssetTrf.fromMapObject(mapList[i]));
    }
    print(count);

    return trxHeader;
  }

  //insert
  Future<int> insertDataTrx(
      ListAssetTrf dataHeader, List<ListAssetTrfLine> dataline) async {
    Database db = await this.databaseHelper.database;

    await db.transaction((txn) async {
      var batch = txn.batch();
      batch.insert(TableTrfHeader.tableAssetHeader, dataHeader.toMap());

      await batch.commit(noResult: true);
    });

    await db.transaction((txn) async {
      var batch = txn.batch();
      dataline.forEach((c) async {
        batch.insert(TableTrfLine.tableAssetLine, c.toMap());
      });

      await batch.commit(noResult: true);
    });
    return 1;
  }

  //select
  Future<List<Map<String, dynamic>>> getDataListLine(int idHeader) async {
    Database db = await this.databaseHelper.database;
    var result = await db.query(TableTrfLine.tableAssetLine,
        where: 'toolRequestId = $idHeader');

    return result;
  }

  Future<List<Map<String, dynamic>>> getDataListLineMany(int idHeader) async {
    Database db = await this.databaseHelper.database;
    var result = await db.query(TableTrfLine.tableAssetLine,
        where: 'toolRequestId in$idHeader');

    return result;
  }

  //convert to model
  Future<List<ListAssetTrfLine>> fetchdatalistLine(int idHeader) async {
    var mapList = await getDataListLine(idHeader);
    int count = mapList.length;
    List<ListAssetTrfLine> trxLines = [];

    for (int i = 0; i < count; i++) {
      trxLines.add(ListAssetTrfLine.fromMapObject(mapList[i]));
    }

    return trxLines;
  }

  //update
  //delete

  Future<int> deleteAllData(int idHeader) async {
    Database db = await this.databaseHelper.database;

    var resultline = await db.delete(TableTrfLine.tableAssetLine,
        where: '${TableTrfLine.toolRequestID}= $idHeader');

    var result = await db.delete(TableTrfHeader.tableAssetHeader,
        where: '${TableTrfHeader.toolRequestID}= $idHeader');
    return result;
  }

  Future<int> deleteAllTransaction() async {
    Database db = await this.databaseHelper.database;

    var resultline = await db.delete(
      TableTrfLine.tableAssetLine,
    );

    var result = await db.delete(
      TableTrfHeader.tableAssetHeader,
    );
    return result;
  }
}
