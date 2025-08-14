import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_header.dart';
import 'package:sqflite/sqflite.dart';

class TableMovementReqHeader {
  //table_name
  static String tableMovementRequestHeader = 'movementRequestHeader';

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
}

class QueryTableHeader {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late TableMovementReqHeader tableAssetRcv;

  //select
  Future<List<Map<String, dynamic>>> getDataList() async {
    Database db = await this.databaseHelper.database;
    var result =
        await db.query(TableMovementReqHeader.tableMovementRequestHeader);
    return result;
  }

  //convert to model
  Future<List<ListDataMovReqHeader>> fetchdatalist() async {
    var mapList = await getDataList();
    int count = mapList.length;
    List<ListDataMovReqHeader> prodList = [];

    for (int i = 0; i < count; i++) {
      prodList.add(ListDataMovReqHeader.fromMapObject(mapList[i]));
    }
    print(count);

    return prodList;
  }

  //insert
  Future<int> insertDataTrx(List<ListDataMovReqHeader> header) async {
    Database db = await this.databaseHelper.database;
    await db.transaction((txn) async {
      var batch = txn.batch();
      header.forEach((c) async {
        // await txn.rawInsert(
        //     'Insert into ${TableInitList.tableMovementRequest}(${TableInitList.clientId} ,${TableInitList.orgId})'
        //     'values (${c.toMap()})');

        batch.insert(
            TableMovementReqHeader.tableMovementRequestHeader, c.toMap());
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
    var result =
        await db.delete(TableMovementReqHeader.tableMovementRequestHeader);

    return result;
  }
}
