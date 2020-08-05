class CallBackQuery {
  String id;
  User userId;
  int msgId, chatId;
  String inline_message_id;
  String data;
  CallBackQuery(
      {this.data,
      this.id,
      this.inline_message_id,
      this.userId,
      this.chatId,
      this.msgId});

  factory CallBackQuery.fromJSON(Map<String, dynamic> object) {
    try {
      return CallBackQuery(
        chatId: object['message']['chat']['id'],
        msgId: object['message']['message_id'],
        data: object['data'] as String,
        inline_message_id: object.containsKey('inline_message_id')
            ? object['inline_message_id']
            : '',
        id: object['id'],
        userId: User.fromJson(object['from'] as Map<String, dynamic>),
      );
    } catch (e) {
      print('exception at callback model:${e}');
    }
  }
}

class User {
  int id;
  String first_name, last_name, username;
  bool is_bot;

  User({this.is_bot, this.first_name, this.id, this.last_name, this.username});
  factory User.fromJson(Map<String, dynamic> user) {
    return User(
      id: user['id'],
      username: user['username'] as String,
      is_bot: user['is_bot'] as bool,
      first_name: user['first_name'] as String,
      last_name: user['last_name'] as String,
    );
  }
}
