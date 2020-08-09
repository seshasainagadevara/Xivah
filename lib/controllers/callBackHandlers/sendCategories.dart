import 'dart:async';

import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../replySender.dart';

class SendCategories{

SendCategories();

  Future<void> sendCategories(
      Db database, num chatId, String name, String botUrl, String collection, num port, num msgId) async {
//    await ClientForReply().replyWith(
//        url: '${botUrl}/deleteMessage',
//        port:port,
//        data: {
//          'chat_id': chatId,
//          'message_id': msgId-1
//        });
    return await database
        .collection(collection)
        .find(where.excludeFields(['items']))
        .transform(StreamTransformer<Map<String, dynamic>,
        InlineKeyboardButton>.fromHandlers(
        handleData: (data, sink) => sink.add(
            InlineKeyboardButton.categoryFromJson(data,
                addition: collection)),
        handleError: (error, stacktrace, sink) => sink.add(error),
        handleDone: (sink) async {
          sink.close();
        }))
        .toList()
        .then((buttons) async => await ReplySender(
        port: port,
        chatId: chatId,
        botUrl: botUrl,
        text:
        ' Namaskaram 🙏🏼 <i>${name}</i>😎. Select a category of your choice 👇',
        buttons: buttons)
        .sendReply())
        .then((value) async {})
        .catchError((error) async {
      print('error came at start command ${error} ');
      await database.close();
    });
  }


}