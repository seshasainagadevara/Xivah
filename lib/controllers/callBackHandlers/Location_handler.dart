import 'dart:async';

import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/callBackHandlers/sendCategories.dart';
import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/structures/MsgStrucutures/create_user_model.dart';
import 'package:Xivah/structures/MsgStrucutures/sendMessageModel.dart';
import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';
import 'package:Xivah/structures/replykeyboards/remove_reply_keyboard.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../replySender.dart';

class LocationHandler {
  final List _details;
  String _apiUrl;
  SendCategories _sendCategories;
  ClientForReply _clientForReply;
  // Map<String, dynamic> _data;
  final String _collection = 'categories';
  DatabaseConnect _databaseConnect;
  LocationHandler(this._details) {
    _apiUrl = _details[2] + 'bot' + _details[1];
    _clientForReply = ClientForReply();
    _databaseConnect = DatabaseConnect();
    _sendCategories = SendCategories();
  }

  processLocation(Map<String, dynamic> data) async {
    var chatId = data['message']['chat']['id'];
    var name = data['message']['from']['first_name'];
    await ClientForReply().replyWith(
        url: '${_apiUrl}/deleteMessage',
        port: _details[0],
        data: {
          'chat_id': chatId,
          'message_id': data['message']['message_id'] - 1
        });
    await _clientForReply
        .replyWith(port: _details[0], url: _apiUrl + '/sendMessage', data: {
      'chat_id': chatId,
      'text': "YaY! 🤚 that's cool. 🤩 🥳",
      //'reply_markup': RemoveReplyKeyboard(true).removeReplyKeyboard()
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
          .then((value) async {
        await ClientForReply().replyWith(
            url: '${_apiUrl}/deleteMessage',
            port: _details[0],
            data: {
              'chat_id': chatId,
              'message_id': data['message']['message_id']
            });
        await _sendCategories.sendCategories(
            database, chatId, name, _apiUrl, _collection, _details[0], data['message']['message_id']);
      }).catchError((e) => "error at location ${e}");
//        }
    });
  }
}
