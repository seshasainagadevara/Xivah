import 'package:mongo_dart/mongo_dart.dart';

class TimeDifferenceChecker {
  final Db _db;
  final Timestamp _timestamp;
  final num userId;

  TimeDifferenceChecker(this._db, this._timestamp, this.userId);

  diffCheck() async {
//        await _db.collection('people').aggregate([
//        {
//          '\$match': {
//            'userId': data['message']['from']['id'],
//          }
//        },
//        {
//          '\$project': {'modified': 1}
//        }
//      ], cursor: {
//        'batchSize': 1
//      }).then((cursor) async {
//        print(cursor);
//        var _time = (cursor['cursor']['firstBatch'][0]['modified'] as Timestamp)
//            .seconds;
//        if ((Timestamp().seconds - _time) ~/ 60 > 10) {
  }
}
