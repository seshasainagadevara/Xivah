import 'package:Xivah/structures/custom_keyboard.dart';

class SendMessageData {
  num chat_id;
  String parse_mode, text;
  bool disable_web_page_preview, disable_notification;
  //  reply_to_message_id;
  CustomKeyboard keyboard;

  SendMessageData(
    this.chat_id,
    this.text, {
    this.disable_notification,
    this.disable_web_page_preview,
    this.parse_mode,
    this.keyboard,
  });

  Map<String, dynamic> sendMessageJSON() {
    return {
      'chat_id': chat_id,
      'text': text,
      'parse_mode': parse_mode,
      'disable_web_page_preview': disable_web_page_preview ?? false,
      'disable_notification': disable_notification ?? false,
      // 'reply_to_message_id': reply_to_message_id,
      'reply_markup': keyboard == null ? '' : keyboard?.sendKeyBoard()
    };
  }
}
