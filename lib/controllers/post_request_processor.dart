import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/callBackHandlers/addToCartHandler.dart';
import 'package:Xivah/controllers/callBackHandlers/sendChatAction.dart';
import 'package:Xivah/controllers/commands/SendMail.dart';
import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/controllers/replySender.dart';
import 'package:Xivah/structures/MsgStrucutures/msg_model.dart';
import 'package:Xivah/structures/inlineKeyboards/answer_call_back_query.dart';
import 'package:Xivah/structures/inlineKeyboards/callback_query.dart';
import 'package:Xivah/structures/inlineKeyboards/inline_keyboard.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'callBackHandlers/category_callback_handler.dart';
import 'commands/start_comand.dart';

const List botCommands = <String>[
  '/start',
  '/orders',
  '/contact',
  '/feedback',
  '/science',
];

class PostRequestProcessor {
  final List _details;
  String _apiUrl;
  ClientForReply _clientForReply;
  DatabaseConnect _databaseConnect;

  PostRequestProcessor(this._details) {
    //update cart
    _databaseConnect = DatabaseConnect();
    _apiUrl = _details[2] + 'bot' + _details[1];

    _clientForReply = ClientForReply();
  }

  void processBotCommand(Map request) async {
    var msg = MsgModel.readFromMap(request);
    await SendChatAction(url: _apiUrl, port: _details[0], chatId: msg.chatId)
        .sendAction();
    //commands handling
    final command = botCommands
        .firstWhere((e) => msg.message.trim().contains(e), orElse: () => null);
    print('command: $command');
    if (command != null) {
      switch (command) {
        case '/start':
          await StartCommand(
                  chatId: msg.chatId,
                  username: msg.userName,
                  msgId: msg.msgId,
                  senderId: msg.senderId,
                  botUrl: _apiUrl,
                  port: _details[0],
                  type: msg.typeOfChat,
                  name: msg.firstName)
              .performStart();
          break;
        case '/contact':
          await ReplySender(
                  chatId: msg.chatId,
                  port: _details[0],
                  botUrl: _apiUrl,
                  text:
                      "VedikBharath is the product of <b>Imagtorel Technologies pvt. ltd.</b>\n"
                      "For any queries you could write to: <i>vedikbharath@gmail.com</i> \n"
                      "contact us at:📞 +91 7013869169.")
              .sendReply();
          break;
        case '/feedback':
          await ReplySender(
                  chatId: msg.chatId,
                  port: _details[0],
                  botUrl: _apiUrl,
                  text:
                      "Hey feedback📝 is the most important part of our growth🥺 and for the enhancement of quality of our service."
                      "\n<b>Please, send us your valuable feedback and suggestions.✍️</b>"
                      "\n<strong> <i>start writing your feedback with this 😀👉(feedback:) keyword.</i></strong>")
              .sendReply();
          break;

        case '/orders':
          await _databaseConnect.openDBConnection().then((database) async {
            await database
                .collection('orders')
                .find(where
                    .eq('userId', msg.senderId)
                    .fields(['orderItem', 'price', 'date']))
                .toList()
                .then((value) async {
              print(value);
              await database.close();
              var str = '';
              value.forEach((element) {
                str =
                    "${str.trim()}${element['orderItem']}\nprice: ${element['price']}\non: ${element['date'].split('.')[0].replaceAll('T', ' Time: ')}\n\n===";
              });
              await ReplySender(
                      chatId: msg.chatId,
                      port: _details[0],
                      botUrl: _apiUrl,
                      text:
                          "<strong> Hey, these are your orders..</strong>\n\n ${str}")
                  .sendReply();
            });
          }).catchError((e) => print('erro at order: ${e}'));

          break;
        case '/science':
          await ReplySender(
                  chatId: msg.chatId,
                  port: _details[0],
                  botUrl: _apiUrl,
                  text:
                      "👩‍⚕️ \n\n <i>Hey did you know that,  with homam we can purify air, increase immunity power of our body and also keeps our mind calm and active.</i>\n\n"
                      "<strong>The way HOMAM injects medicine into our body is called 'DRUG DELIVERY THROUGH INHALATION' method.\nIsn't it great and amazing😱 right?</strong>"
                      "\nLet's order Dhanvantari homam now, in this time of corona it is most powerful.\n"
                      "/start")
              .sendReply();
          break;
      }
    } else {
      print('${msg.message} == bot command');
    }
  }

  void processPhoneNumber(Map request) async {
    var msg = MsgModel.readFromMap(request);
    Map loc;
    await SendChatAction(url: _apiUrl, port: _details[0], chatId: msg.chatId)
        .sendAction();
    if (msg.message.trim().contains(RegExp(r'^([0-9]){10}$'))) {
      return _databaseConnect.openDBConnection().then((database) {
        database
            .collection('people')
            .update(where.eq('userId', msg.senderId),
                modify.set('phone', msg.message.trim()))
            .then((_) async {
          await database.collection('orders').update(
              where.eq('userId', msg.senderId),
              modify.set('phone', msg.message.trim()));
          await database
              .collection('people')
              .findOne(where
                  .eq('userId', msg.senderId)
                  .fields(['location.coordinates']))
              .then((value) async {
            loc = value;
            await database
                .collection('orders')
                .update(
                    where.eq('userId', msg.senderId),
                    modify.set('location', {
                      'longitude': loc['location']['coordinates'][0],
                      'latitude': loc['location']['coordinates'][1]
                    }))
                .then((_) async => await database.collection('orders').update(
                    where.eq('userId', msg.senderId),
                    modify.set('date', DateTime.now().toIso8601String())))
                .then((value) async => await database
                    .collection('orders')
                    .update(where.eq('userId', msg.senderId),
                        modify.set('name', msg.firstName)));
          }).then((_) async {
            await SendMail(
              name: msg.firstName,
              userId: msg.senderId,
              item: 'Homam dhanvantari',
              date: DateTime.now().toIso8601String(),
              location: {
                'longitude': loc['location']['coordinates'][0],
                'latitude': loc['location']['coordinates'][1]
              },
              phone: msg.message,
            ).sendMailMe();
          });
          await ClientForReply().replyWith(
              url: '${_apiUrl}/deleteMessage',
              port: _details[0],
              data: {
                'chat_id': msg.chatId,
                'message_id': msg.msgId - 1,
              });
          await ClientForReply().replyWith(
              url: '${_apiUrl}/deleteMessage',
              port: _details[0],
              data: {
                'chat_id': msg.chatId,
                'message_id': msg.msgId,
              });
          await ReplySender(
            botUrl: _apiUrl,
            port: _details[0],
            chatId: msg.chatId,
            text:
                "<strong>Your order has been placed successfully 🥳!! thank you very much 🧘<i>${msg.firstName} garu</i> for pioneering great vedic science</strong>,\nour VedikBharath executive would be in contact with you.",
          ).sendReply();
          await database.close();
        });
      }).catchError((e) => print('error storing phone number ${e}'));
    }

    await ReplySender(
      botUrl: _apiUrl,
      port: _details[0],
      chatId: msg.chatId,
      text: 'Hey, please send valid phone number.</strong>',
    ).sendReply();
  }

  void processNormalText(Map request) async {
    var msg = MsgModel.readFromMap(request);
    await SendChatAction(url: _apiUrl, port: _details[0], chatId: msg.chatId)
        .sendAction();

    if (msg.message.contains('feedback:') ||
        msg.message.contains('feedback') ||
        msg.message.contains('feed back') ||
        msg.message.contains(RegExp(r'(feedback)', caseSensitive: false))) {
      return _databaseConnect.openDBConnection().then((database) {
        database.collection('feedbacks').insert({
          'username': msg.userName,
          'name': msg.firstName + msg.lastName,
          'id': msg.senderId,
          'chatId': msg.chatId,
          'typeOf': msg.typeOfChat,
          'feedback': msg.message,
        }).then((value) async {
          await database.close();
          await ReplySender(
            botUrl: _apiUrl,
            port: _details[0],
            chatId: msg.chatId,
            text:
                'Dhanyavadhamulu🙏 for your valuable feedback, it means a lot to us.😍🥰 ',
          ).sendReply();
        });
      });
      //store feedbackin db and send thanks for your feedback

    }
    await ClientForReply()
        .replyWith(url: '${_apiUrl}/deleteMessage', port: _details[0], data: {
      'chat_id': msg.chatId,
      'message_id': msg.msgId,
    });
    return await ReplySender(
      botUrl: _apiUrl,
      port: _details[0],
      chatId: msg.chatId,
      text:
          'Hey, you could try these options:\n <strong> /start - Start ordering Homam </strong>',
    ).sendReply();
  }

  void processCallBackquery(Map value) async {
    var _callback = CallBackQuery.fromJSON(value['callback_query']);
    await SendChatAction(
            url: _apiUrl, port: _details[0], chatId: _callback.chatId)
        .sendAction();
    var _answerquery = AnswerCallBackQuery(_callback.id,
        show_alert: false, text: '', cache_time: 0.1);
    await _clientForReply.replyWith(
      url: '${_apiUrl}/answerCallbackQuery',
      port: _details[0],
      data: _answerquery.answerQuery(),
    );

    var _collectionDetails = _callback.data.split(':');

    if (_collectionDetails.length > 2) {
      if (_collectionDetails[0].contains('buy')) {
        await CategoryCallbackHandler(_collectionDetails[1], _apiUrl,
                _callback.chatId, _callback.msgId, _details[0])
            .processItems(
                itemId: _collectionDetails[2],
                type: 'buy',
                senderId: _callback.userId.id);

        await ReplySender(
          botUrl: _apiUrl,
          port: _details[0],
          chatId: _callback.chatId,
          text:
              '🥰 Great! Inorder to complete the booking, just send your working mobile number, \n without +91.\n (just type only mobile number)',
        ).sendReply();
      }
//      if (_collectionDetails[0].contains('qty')) {
//        await _databaseConnect.openDBConnection().then((database) async {
//          await database
//              .collection('people')
//              .update(where.eq('userId', _callback.userId.id),
//                  modify.set('cache_area', int.parse(_collectionDetails[3])))
//              .then((value) async {
//            await CategoryCallbackHandler(_collectionDetails[1], _apiUrl,
//                    _callback.chatId, _callback.msgId, _details[0])
//                .processItems(
//                    itemId: _collectionDetails[2],
//                    qty: int.parse(_collectionDetails[3]));
//          });
//          await database.close();
//        });
//      }
//      else if(_collectionDetails[0].contains('add')){
//        await AddToCartHandler(userId: _callback.userId.id).addToCart();
//
//      }
    } else {
      if (_collectionDetails[0].contains('categories')) {
        await CategoryCallbackHandler(_collectionDetails[1], _apiUrl,
                _callback.chatId, _callback.msgId, _details[0])
            .processCategories();
      } else {
        await CategoryCallbackHandler(_collectionDetails[0], _apiUrl,
                _callback.chatId, _callback.msgId, _details[0])
            .processItems(itemId: _collectionDetails[1]);
      }
    }
  }
}
