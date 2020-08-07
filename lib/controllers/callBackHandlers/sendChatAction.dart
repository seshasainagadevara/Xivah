import 'package:Xivah/client/client_for_reply.dart';

class SendChatAction {
  final String url;
  final num port;
  final num chatId;
  ClientForReply _clientForReply;
  SendChatAction({this.url, this.port, this.chatId}) {
    _clientForReply = ClientForReply();
  }

  Future<void> sendAction() async {
    return await _clientForReply.replyWith(
        url: url + '/sendChatAction',
        data: {'chat_id': chatId, 'action': 'typing'},
        port: port);
  }
}
