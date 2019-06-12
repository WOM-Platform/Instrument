//import 'package:instrument/src/db/aim_db.dart';
//import 'package:wom_package/wom_package.dart';
//import 'api.dart';
//
//class AimRepository {
//  AimDb _aimDb;
//  AimApiProvider _apiProvider;
//
//  AimRepository() {
//    _apiProvider = AimApiProvider();
//    _aimDb = AimDb.get();
//  }
//
//  // check if there is update of Aim
//  updateAim() async {
//    final newList = await _apiProvider.checkUpdate();
//    if (newList != null) {
//      saveAimToDb(newList);
//    }
//  }
//
//  Future<Aim> getAim(String aimCode)async{
//    return await _aimDb.getAim(aimCode);
//  }
//
//  Future<List<Aim>> getAimList() async {
//    try {
//      List<Aim> rootList = await _aimDb.getAimWithLevel(deepLevel: 1);
//      if (rootList.isEmpty) {
//        final list = await _apiProvider.getAims();
//        await saveAimToDb(list);
//        rootList = await _aimDb.getAimWithLevel(deepLevel: 1);
//      }
//
//      print("START READING");
//      for (final aim in rootList) {
//        aim.children =
//            await _aimDb.getAimWithLevel(deepLevel: 2, code: aim.code);
//        for (final aim in aim.children) {
//          aim.children =
//              await _aimDb.getAimWithLevel(deepLevel: 3, code: aim.code);
//        }
//      }
//
//      print("END READING");
//      return rootList;
//    } catch (ex) {
//      throw ex;
//    }
//  }
//
////  _getAimListFromNetwork() async {
////    print("DOWNLOADING AIM");
////    return await _apiProvider.getAims();
////  }
//
//  saveAimToDb(List<Aim> list) async {
//    print("SAVING AIM");
//    list.forEach(
//      (aim) async {
//        _aimDb.insert(aim);
//      },
//    );
//    print("AIM SAVED");
//  }
//}
