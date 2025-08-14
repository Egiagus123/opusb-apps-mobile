import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_line.dart';
import 'package:sqflite/sqflite.dart';

class TableMovementReqLine {
  //table_name
  static String tableMovementRequestLine = 'movementRequestLine';

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

class QueryTableLine {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late TableMovementReqLine tableAssetRcv;

  //select
  Future<List<Map<String, dynamic>>> getDataList() async {
    Database db = await this.databaseHelper.database;
    var result = await db.query(TableMovementReqLine.tableMovementRequestLine);
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
  Future<int> insertDataTrx(List<ListDataMovReqLine> value) async {
    Database db = await this.databaseHelper.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      value.forEach((c) async {
        // await txn.rawInsert(
        //     'Insert into ${TableInitList.tableMovementRequest}(${TableInitList.clientId} ,${TableInitList.orgId})'
        //     'values (${c.toMap()})');

        batch.insert(TableMovementReqLine.tableMovementRequestLine, c.toMap());
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
    var result = await db.delete(TableMovementReqLine.tableMovementRequestLine);
    return result;
  }

  Future<List<Map<dynamic, dynamic>>> searchLineBySerno(
      int headerID, String serno) async {
    Database db = await this.databaseHelper.database;

    var result = await db.rawQuery(
        "SELECT * FROM ${TableMovementReqLine.tableMovementRequestLine} where ${TableMovementReqLine.toolRequestID} = $headerID and  ${TableMovementReqLine.serNo} = '$serno' ");
    return result;
  }

  Future<List<ListDataMovReqLine>> addLineBySerno(
      int headerID, String serno) async {
    // Fetch the list of maps from the search function
    var lineMapList = await searchLineBySerno(headerID, serno);

    // Ensure lineMapList is a List<Map<String, dynamic>>
    if (lineMapList == null) {
      return [];
    }

    int count = lineMapList.length;
    List<ListDataMovReqLine> lineList = [];

    // Iterate through the map list and create the ListDataMovReqLine objects
    for (int i = 0; i < count; i++) {
      lineList.add(ListDataMovReqLine.fromMapObject(
          lineMapList[i] as Map<String, dynamic>));
    }

    return lineList;
  }
}
