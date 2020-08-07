import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/callBackHandlers/addToCartHandler.dart';
import 'package:Xivah/controllers/callBackHandlers/sendChatAction.dart';
import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/controllers/replySender.dart';
import 'package:Xivah/structures/MsgStrucutures/msg_model.dart';
import 'package:Xivah/structures/inlineKeyboards/answer_call_back_query.dart';
import 'package:Xivah/structures/inlineKeyboards/callback_query.dart';
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

  void processNormalText(Map request) async {
    var msg = MsgModel.readFromMap(request);
    await SendChatAction(url: _apiUrl, port: _details[0], chatId: msg.chatId)
        .sendAction();

    if (msg.message.contains('feedback:') ||
        msg.message.contains('feedback') ||
        msg.message.contains('feed back') ||
        msg.message.contains(RegExp(r'(feedback)'))) {
      return _databaseConnect.openDBConnection().then((database) {
        database.collection('feedbacks').insert({
          'username': msg.userName,
          'name': msg.firstName + msg.lastName,
          'id': msg.senderId,
          'chatId': msg.chatId,
          'typeOf': msg.typeOfChat,
          'feedback': msg.message,
        }).then((value) async => await ReplySender(
              botUrl: _apiUrl,
              port: _details[0],
              chatId: msg.chatId,
              text:
                  'Dhanyavadhamulu🙏 for your valuable feedback, it means a lot to us.😍🥰 ',
            ).sendReply());
      });
      //store feedbackin db and send thanks for your feedback

    }
    return await ReplySender(
      botUrl: _apiUrl,
      port: _details[0],
      chatId: msg.chatId,
      text: 'Hey, you could try these options:\n <strong> /start - Start ordering Homam </strong>',
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
      if (_collectionDetails[0].contains('buy')) {}
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
