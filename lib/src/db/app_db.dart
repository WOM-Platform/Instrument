import 'dart:async';
import 'dart:io';
import 'package:wom_package/wom_package.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

/// This is the singleton database class which handlers all database transactions
/// All the task raw queries is handle here and return a Future<T> with result
class AppDatabase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  //private internal constructor to make it singleton
  AppDatabase._internal();

  Database _database;

  static AppDatabase get() {
    return _appDatabase;
  }

  final _lock = new Lock();

  Future<Database> getDb() async {
    if (_database == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_database == null) {
          await _init();
        }
      });
    }
    return _database;
  }

  Future _init() async {
    print("AppDatabase: init database");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "instrument.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await AimDbHelper.createAimTable(db);
      await _createRequestTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE ${Aim.TABLE_NAME}");
      await db.execute("DROP TABLE ${WomRequest.TABLE}");
      await AimDbHelper.createAimTable(db);
      await _createRequestTable(db);

    });
  }

  Future _createRequestTable(Database db) {
    return db.execute("CREATE TABLE ${WomRequest.TABLE} ("
        "${WomRequest.ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${WomRequest.AIM_CODE} TEXT,"
        "${WomRequest.AIM_NAME} TEXT,"
        "${WomRequest.PASSWORD} TEXT,"
        "${WomRequest.SOURCE_ID} TEXT,"
        "${WomRequest.DEEP_LINK} TEXT,"
        "${WomRequest.NONCE} TEXT,"
        "${WomRequest.NAME} TEXT,"
        "${WomRequest.AMOUNT} INTEGER,"
        "${WomRequest.STATUS} INTEGER,"
        "${WomRequest.LATITUDE} LONG,"
        "${WomRequest.LONGITUDE} LONG,"
        "${WomRequest.URL} TEXT,"
        "${WomRequest.DATE} INTEGER);");
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database.isOpen) {
      await _database.close();
      _database = null;
      print("database closed");
    }
  }
}
