import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/tablemovementreq_line.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'table_trxasset.dart';
import 'tablemovementreq_header.dart';
import 'table_assetrcv.dart';

class DatabaseHelper {
  static DatabaseHelper? _dbHelper; //singleton DatabaseHelper
  DatabaseHelper._createInstance();
  Database? _db;

  FlutterSecureStorage? secureStorage;

  factory DatabaseHelper() {
    if (_dbHelper == null) {
      _dbHelper = DatabaseHelper._createInstance(); //pas ga ada data samsek
    }

    return _dbHelper!;
  }
  Future<Database> get database async {
    if (_db == null) {
      _db = await initializedDatabase();
    }
    return _db!;
  }

  Future<Database> initializedDatabase() async {
    //get the directory path for android to store db.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'assetoffline.db';

    //open or create the database at given path
    var localDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return localDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    //MOVEMENT REQUEST HEADER COLUMN QUERY
    await db.execute(
        'CREATE TABLE ${TableMovementReqHeader.tableMovementRequestHeader}'
        '(${TableMovementReqHeader.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${TableMovementReqHeader.clientId} INTEGER, '
        '${TableMovementReqHeader.orgId} INTEGER, '
        '${TableMovementReqHeader.toolRequestID} INTEGER ,'
        '${TableMovementReqHeader.locatorID} INTEGER ,'
        '${TableMovementReqHeader.locatorNewID} INTEGER ,'
        '${TableMovementReqHeader.documentNo} TEXT ,'
        '${TableMovementReqHeader.dateDoc} TEXT ,'
        '${TableMovementReqHeader.dateRequired} TEXT ,'
        '${TableMovementReqHeader.dateReceived} TEXT ,'
        '${TableMovementReqHeader.locationfromName} TEXT ,'
        '${TableMovementReqHeader.locationToName} TEXT)');

    //MOVEMENT REQUEST Line COLUMN QUERY
    await db.execute(
        'CREATE TABLE ${TableMovementReqLine.tableMovementRequestLine}'
        '(${TableMovementReqLine.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${TableMovementReqLine.clientId} INTEGER, '
        '${TableMovementReqLine.orgId} INTEGER, '
        '${TableMovementReqLine.toolRequestLineID} INTEGER, '
        '${TableMovementReqLine.toolRequestID} INTEGER, '
        '${TableMovementReqLine.installBaseID} INTEGER, '
        '${TableMovementReqLine.installBaseName} TEXT,'
        '${TableMovementReqLine.serNo} TEXT, '
        '${TableMovementReqLine.qtyDelivered} NUMERIC, '
        '${TableMovementReqLine.qtyEntered} NUMERIC)');

    //Asset Trx HEADER COLUMN QUERY
    await db.execute('CREATE TABLE ${TableTrfHeader.tableAssetHeader}'
        '(${TableTrfHeader.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${TableTrfHeader.clientId} INTEGER, '
        '${TableTrfHeader.orgId} INTEGER, '
        '${TableTrfHeader.toolRequestID} INTEGER ,'
        '${TableTrfHeader.locatorID} INTEGER ,'
        '${TableTrfHeader.locatorNewID} INTEGER ,'
        '${TableTrfHeader.documentNo} TEXT ,'
        '${TableTrfHeader.dateDoc} TEXT ,'
        '${TableTrfHeader.dateRequired} TEXT ,'
        '${TableTrfHeader.dateReceived} TEXT ,'
        '${TableTrfHeader.locationfromName} TEXT ,'
        '${TableTrfHeader.locationToName} TEXT ,'
        '${TableTrfHeader.trxtype} TEXT)');

    //Asset Trx Line COLUMN QUERY
    await db.execute('CREATE TABLE ${TableTrfLine.tableAssetLine}'
        '(${TableTrfLine.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${TableTrfLine.clientId} INTEGER, '
        '${TableTrfLine.orgId} INTEGER, '
        '${TableTrfLine.toolRequestLineID} INTEGER, '
        '${TableTrfLine.toolRequestID} INTEGER, '
        '${TableTrfLine.installBaseID} INTEGER, '
        '${TableTrfLine.installBaseName} TEXT,'
        '${TableTrfLine.serNo} TEXT, '
        '${TableTrfLine.qtyDelivered} NUMERIC, '
        '${TableTrfLine.qtyEntered} NUMERIC)');

    //Get Data Receiving COLUMN QUERY
    await db.execute('CREATE TABLE ${TableGetAssetReceiving.tableReceiving}'
        '(${TableGetAssetReceiving.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${TableGetAssetReceiving.clientId} INTEGER, '
        '${TableGetAssetReceiving.orgId} INTEGER, '
        '${TableGetAssetReceiving.toolRequestLineID} INTEGER, '
        '${TableGetAssetReceiving.toolRequestId} INTEGER, '
        '${TableGetAssetReceiving.installBaseID} INTEGER, '
        '${TableGetAssetReceiving.installBaseName} TEXT, '
        '${TableGetAssetReceiving.locatorNewID} INTEGER, '
        '${TableGetAssetReceiving.locationToName} TEXT, '
        '${TableGetAssetReceiving.trxtype} TEXT, '
        '${TableGetAssetReceiving.serNo} TEXT, '
        '${TableGetAssetReceiving.qtyEntered} NUMERIC, '
        '${TableGetAssetReceiving.locatorIntransitID} INTEGER, '
        '${TableGetAssetReceiving.dateReceived} TEXT, '
        '${TableGetAssetReceiving.trfdatedoc} TEXT, '
        '${TableGetAssetReceiving.trfdocno} TEXT )');
  }
}
