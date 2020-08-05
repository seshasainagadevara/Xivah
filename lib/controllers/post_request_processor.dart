import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/replySender.dart';
import 'package:Xivah/structures/MsgStrucutures/msg_model.dart';
import 'package:Xivah/structures/inlineKeyboards/answer_call_back_query.dart';
import 'package:Xivah/structures/inlineKeyboards/callback_query.dart';

import 'callBackHandlers/category_callback_handler.dart';
import 'commands/start_comand.dart';

const List botCommands = <String>[
  '/start',
  '/orders',
  '/cart',
  '/contact',
  '/feedback',
];

class PostRequestProcessor {
  final List _details;
  String _apiUrl;
  ClientForReply _clientForReply;

  PostRequestProcessor(this._details) {
    //update cart

    _apiUrl = _details[2] + 'bot' + _details[1];

    _clientForReply = ClientForReply();
  }

  void processBotCommand(Map request) {
    var msg = MsgModel.readFromMap(request);
    //commands handling
    final command = botCommands
        .firstWhere((e) => msg.message.trim().contains(e), orElse: () => null);
    print('command: $command');
    if (command != null) {
      switch (command) {
        case '/start':
          StartCommand(
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
          break;
        case '/feedback':
          break;
      }
    } else {
      print('${msg.message} == bot command');
    }
  }

  void processNormalText(Map request) async {
    var msg = MsgModel.readFromMap(request);
    print('${msg.message} == normal message');
    await ReplySender(
      botUrl: _apiUrl,
      port: _details[0],
      chatId: msg.chatId,
      text:
          'You can try these options:<pre> <i> /start - Choosing products</i> </pre>',
    ).sendReply();
  }

  void processCallBackquery(Map value) async {
    try {
      var _callback = CallBackQuery.fromJSON(value['callback_query']);
      var _answerquery = AnswerCallBackQuery(_callback.id,
          show_alert: false, text: '', cache_time: 0.1);
      await _clientForReply.replyWith(
        url: '${_apiUrl}/answerCallbackQuery',
        port: _details[0],
        data: _answerquery.answerQuery(),
      );

      var _collectionDetails = _callback.data.split(':');
      if (_collectionDetails.length > 2) {
        if(_collectionDetails[0].contains('qty')){
          await CategoryCallbackHandler(_collectionDetails[1], _apiUrl,
              _callback.chatId, _callback.msgId, _details[0])
              .processItems(itemId: _collectionDetails[2], qty: int.parse(_collectionDetails[3]));
        }

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
    } catch (e) {
      print('error  ${e}');
    }
  }
}
