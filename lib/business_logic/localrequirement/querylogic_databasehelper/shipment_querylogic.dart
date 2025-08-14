import 'package:apps_mobile/business_logic/localrequirement/databasehelper/databasehelper.dart';
import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:sqflite/sqflite.dart';

class ShipmentQuery {
  DatabaseHelper databaseHelper = DatabaseHelper();
  static const String tablename = 'offline_shipmentobject';

  Future<int> insertShipmentObject(
      ShipmentOfflineModel shipmentOfflineModel) async {
    Database db = await databaseHelper.database;
    return await db.insert(tablename, shipmentOfflineModel.toMap());
  }

  Future<List<ShipmentOfflineModel>> getAllShipmentObjects() async {
    Database db = await databaseHelper.database;
    List<Map<String, dynamic>> maps = await db.query(tablename);
    return List.generate(maps.length, (i) {
      return ShipmentOfflineModel.fromMap(maps[i]);
    });
  }

  Future<int> updateShipmentObject(
      int id, ShipmentOfflineModel shipmentOfflineModel) async {
    Database db = await databaseHelper.database;
    return await db.update(
      tablename,
      shipmentOfflineModel.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
