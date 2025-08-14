import 'package:apps_mobile/business_logic/localrequirement/tablestructure_databasehelper/shipment_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database; // Menggunakan nullable type
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Mengambil path untuk database
    String path = await getDatabasesPath();
    path = join(path, 'offline_shipmentdatabase.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${TableShipment.tableShipment}(
          ${TableShipment.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TableShipment.container} TEXT,
          ${TableShipment.clientId} INTEGER,
          ${TableShipment.orgId} INTEGER,
          ${TableShipment.status} INTEGER,
          ${TableShipment.qtyentered} REAL,
          ${TableShipment.quantity} REAL,
          ${TableShipment.tareweight} REAL,
          ${TableShipment.weight1} REAL,
          ${TableShipment.shipmentDate} TEXT)
        ''');

        // Anda bisa menambahkan lebih banyak tabel di bawah ini jika diperlukan
      },
    );
  }
}
