import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/structures/MsgStrucutures/create_user_model.dart';
import 'package:Xivah/structures/MsgStrucutures/sendMessageModel.dart';
import 'package:Xivah/structures/replykeyboards/remove_reply_keyboard.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../replySender.dart';

class LocationHandler {
  final List _details;
  String _apiUrl;
  ClientForReply _clientForReply;
  Map<String, dynamic> _data;
  DatabaseConnect _databaseConnect;
  LocationHandler(this._details) {
    _apiUrl = _details[2] + 'bot' + _details[1];
    _clientForReply = ClientForReply();
    _databaseConnect = DatabaseConnect();
  }

  processLocation(Map<String, dynamic> data) async {
    await _clientForReply
        .replyWith(port: _details[0], url: _apiUrl + '/sendMessage', data: {
      'chat_id': data['message']['chat']['id'],
      'text': "YaY! that's cool",
      'reply_markup': RemoveReplyKeyboard(true).removeReplyKeyboard()
    });



    await _databaseConnect.openDBConnection().then((database) async {
//      await database.collection('people').aggregate([
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
      await database
          .collection('people')
          .update(
              where.eq('userId', data['message']['from']['id']),
              modify.set(
                  'location',
                  ULocation(
                          locationType: 'Point',
                          longitude: data['message']['location']['longitude'],
                          latitude: data['message']['location']['latitude'])
                      .toJson()))
          .then((value) => print(value));
//        }
    });
//
//      await database.close();
//    });
  }
}
