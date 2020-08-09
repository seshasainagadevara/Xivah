import 'dart:async';

import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/callBackHandlers/sendCategories.dart';
import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/controllers/replySender.dart';

import 'package:Xivah/structures/MsgStrucutures/create_user_model.dart';

import 'package:mongo_dart/mongo_dart.dart';

class StartCommand {
  num chatId, port, senderId, msgId;
  String botUrl, name, username, type;
  DatabaseConnect _db;
  final String _collection = 'categories';
  SendCategories _sendCategories;

  StartCommand(
      {this.chatId,
      this.botUrl,
      this.name,
      this.msgId,
      this.username,
      this.type,
      this.port,
      this.senderId}) {
    _sendCategories = SendCategories();
    _db = DatabaseConnect();
  }

  Future<void> performStart() async {
    await _db.openDBConnection().then((database) {
      _db.checkUserRegistration(senderId, 'people').then((timeStamp) async {
        if (timeStamp == null) {
          return await _db
              .createUser(
                  User(
                          name: name,
                          type: type,
                          username: username,
                          userId: senderId)
                      .toJson(),
                  'people')
              .then((value) async {
            if (value) {
              print('user created');
              await ReplySender(
                port: port,
                chatId: chatId,
                botUrl: botUrl,
                text:
                    ' Namaskaram 🙏🏼 <i>${name}</i> 😃, welcome to vedik bharath bot. \n Hey! It\'s awesome when you <strong>send your location</strong>📍, for better discovery.',
//                  reply_keyboard_buttons: [
//                    KeyboardButtons('Send Location', request_location: true)
//                  ]
              ).sendReply();
              await database.close();
            } else {
              print('use r not created failure');
              await database.close();
            }
          }).catchError((e) => print('start command error===> $e'));
        }

        //check for timestamp and ask for location and update db
        else {
          if (((Timestamp().seconds - (timeStamp as Timestamp).seconds) ~/ 60) >
              30) {
            await _db.openDBConnection().then((database) => database
                .collection('people')
                .update(where.eq('userId', senderId),
                    modify.set('modified', Timestamp()))
                .then((value) async => await database.close())
                .catchError((e) => print("error updating time stamp ${e}")));
            await ReplySender(
              port: port,
              chatId: chatId,
              botUrl: botUrl,
              text:
                  ' Dhanyavadh 🙏🏼 <i>${name}</i> 🥰 , welcome back! \n Hey!🖐 It\'s my pleasure to talk with you again. \n <strong> Send your location</strong>📍, for accurate service discovery.😎',
//              reply_keyboard_buttons: [
//                KeyboardButtons(
//                  'Send Location',
//                  request_location: true,
//                )
//              ]
            ).sendReply();
          } else {
            await _sendCategories.sendCategories(
                database, chatId, name, botUrl, _collection, port, msgId);
          }
        }
      });
    });
  }
}
