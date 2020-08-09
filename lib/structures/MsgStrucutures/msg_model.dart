class MsgModel {
  final num senderId, chatId;
  final bool isBot;
  final String firstName, lastName, userName;
  final String typeOfChat;
  final num timeStamp, msgId;
  final String message;

  MsgModel(
      this.senderId,
      this.chatId,
      this.isBot,
      this.msgId,
      this.firstName,
      this.lastName,
      this.userName,
      this.typeOfChat,
      this.timeStamp,
      this.message);

  factory MsgModel.readFromMap(Map<String, dynamic> object) {
    return MsgModel(
        object["message"]["from"]["id"] as num,
        object["message"]["chat"]["id"] as num,
        object["message"]["from"]["is_bot"] as bool,
        object['message']['message_id'] as num,
        object["message"]["from"]["first_name"] as String,
        object["message"]["from"]["last_name"] as String,
        object["message"]["from"]["username"] as String,
        object["message"]["chat"]["type"] as String,
        object["message"]["date"] as num,
        object["message"]["text"] as String);
  }
}
