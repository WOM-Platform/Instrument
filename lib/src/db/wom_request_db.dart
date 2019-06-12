import 'package:instrument/src/db/app_db.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:sqflite/sqflite.dart';

class WomRequestDb {
  static final WomRequestDb _requestDb =
      new WomRequestDb._internal(AppDatabase.get());

  AppDatabase _appDatabase;

  WomRequestDb._internal(this._appDatabase);

  static WomRequestDb get() {
    return _requestDb;
  }

  Future<List<WomRequest>> getRequests() async {
    print("getRequests");
    var db = await _appDatabase.getDb();
    try {
      List<Map> maps = await db.query(
        WomRequest.TABLE,
        orderBy: "${WomRequest.DATE} DESC",
      );
      return maps.map((a) {
        return WomRequest.fromMap(a);
      }).toList();
    } catch (e) {
      print(e.toString());
      return List<WomRequest>();
    }
  }

  Future<WomRequest> getRequest(int id) async {
    var db = await _appDatabase.getDb();
    try {
      List<Map> maps = await db.query(
        WomRequest.TABLE,
        columns: null,
        where: "${WomRequest.ID} = ?",
        whereArgs: [id],
      );
      return WomRequest.fromMap(maps.first);
    } catch (e) {
      print(e.toString());
      throw Exception("WomRequest not find: ${e.toString()}");
    }
  }

  insertRequest(WomRequest womRequest) async {
    var db = await _appDatabase.getDb();
    int result;
    try {
      await db.transaction((Transaction txn) async {
        result = await txn.insert(
          WomRequest.TABLE,
          womRequest.toMap(),
        );
      });
      return result;
    } catch (ex) {
      print(ex.toString());
      throw Exception(ex);
    }
  }

  updateRequest(WomRequest womRequest) async {
    var db = await _appDatabase.getDb();
    int result;
    try {
      await db.transaction((Transaction txn) async {
        result = await txn.update(
          WomRequest.TABLE,
          womRequest.toMap(),
          where: "${WomRequest.ID} = ?",
          whereArgs: [womRequest.id],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return result;
    } catch (ex) {
      print(ex.toString());
      throw Exception(ex);
    }
  }

  Future<int> deleteRequest(int id) async {
    var db = await _appDatabase.getDb();
    return await db.delete(WomRequest.TABLE,
        where: '${WomRequest.ID} = ?', whereArgs: [id]);
  }
}
