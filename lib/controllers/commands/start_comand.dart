import 'dart:async';

import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/controllers/replySender.dart';

import 'package:Xivah/structures/MsgStrucutures/create_user_model.dart';
import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';
import 'package:Xivah/structures/replykeyboards/keyboard_button.dart';
import 'package:Xivah/structures/replykeyboards/reply_keyboard.dart';
import 'package:mongo_dart/mongo_dart.dart';

class StartCommand {
  num chatId, port, senderId;
  String botUrl, name, username, type;
  DatabaseConnect _db;
  final String _collection = 'categories';
  StartCommand(
      {this.chatId,
      this.botUrl,
      this.name,
      this.username,
      this.type,
      this.port,
      this.senderId}) {
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
              _sendCategories(
                database,
                text:
                    ' Namaskaram 🙏🏼 <i>${name}</i> garu😎. Select a category of your choice 👇',
              );
//              Performing homam, is most beneficial for you and the people, animals, nature around you.
            } else {
              print('use r not created failure');
              await database.close();
            }
          }).catchError((e) => print('start command error===> $e'));
        } else {
          _sendCategories(
            database,
            text:
                ' Dhanyavadh 🙏🏼 <i>${name}</i> garu😎. \n It\'s our pleasure to see you again😃 , Order a homam and immunize your body 💪 ',
          );
          print("exists");
        }
      });
    });
  }

  _sendCategories(Db database, {String text}) async {
    await database
        .collection(_collection)
        .find(where.excludeFields(['items']))
        .transform(StreamTransformer<Map<String, dynamic>,
                InlineKeyboardButton>.fromHandlers(
            handleData: (data, sink) => sink.add(
                InlineKeyboardButton.categoryFromJson(data,
                    addition: _collection)),
            handleError: (error, stacktrace, sink) => sink.add(error),
            handleDone: (sink) async {
              sink.close();
            }))
        .toList()
        .then((buttons) async => await ReplySender(
                port: port,
                chatId: chatId,
                botUrl: botUrl,
                text: text,
                buttons: buttons)
            .sendReply())
        .catchError((error) async {
      print('error came at start command ${error} ');
      await database.close();
    });
    await database?.close();
  }
}
