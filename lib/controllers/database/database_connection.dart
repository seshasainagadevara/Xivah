import 'package:Xivah/configuration/databaseConfig/databaseConnection.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseConnect {
  DataBaseConnectionConfig _dbConf;
  Db _db;

  DatabaseConnect() {
    _dbConf = DataBaseConnectionConfig();
    _db = Db('mongodb://${_dbConf.HOST}:${_dbConf.DBport}/${_dbConf.dataB}');
  }

  Future<Db> openDBConnection() async {
    try {
      await _db.open();
      return _db;
    } catch (e) {
      print("database error: $e");
      return null;
    }
  }

  Future<bool> createUser(Map<String, dynamic> query, String collection) async {
    return await _db
        .collection(collection)
        .insert(query)
        .then((value) => true)
        .catchError((e) {
      print('error creating user${e}');
      return false;
    });
  }

//  updateUser(Map query, String collection) async {
//    //await _db.collection(collection).update(selector, document)
//  }
//  readUser(Map query, String collection) async {
//    await _db
//        .collection(collection)
//        .findOne(query)
//        .then((value) => print(value))
//        .catchError((e) => print(e));
//  }

  Future<dynamic> checkUserRegistration(num id, String collection) async {
    return await _db
        .collection(collection)
        .findOne(where.eq('userId', id).fields(['modified']))
        .then((cursor) => (cursor != null) ? cursor['modified'] : null).catchError((e)=> print('errr at check user : $e'));
  }
}
