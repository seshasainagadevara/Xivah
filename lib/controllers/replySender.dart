import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/structures/MsgStrucutures/parse_mode.dart';
import 'package:Xivah/structures/MsgStrucutures/sendMessageModel.dart';
import 'package:Xivah/structures/inlineKeyboards/inline_keyboard.dart';
import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';
import 'package:Xivah/structures/replykeyboards/keyboard_button.dart';
import 'package:Xivah/structures/replykeyboards/reply_keyboard.dart';

class ReplySender {
  final num chatId;
  final String text;
  final List<InlineKeyboardButton> buttons;
  //final List<KeyboardButtons> reply_keyboard_buttons;
  String botUrl;
  final num port;
  SendMessageData _messageData;
  ReplySender({
    this.chatId,
    this.text,
    this.buttons,
    this.port,
    this.botUrl,
    //  this.reply_keyboard_buttons
  }) {
    botUrl += '/sendMessage';
    _messageData = SendMessageData(chatId, text,
        parse_mode: MsgParseMode.HTML, keyboard: buttons==null?null:InlineKeyboard(buttons)
        //buttons == null
        // ? ReplyKeyboard(reply_keyboard_buttons, one_time_keyboard: true)
        //    :
        );
  }

  Future<void> sendReply() async {
    await Future.delayed(
        const Duration(milliseconds: 80),
        () => ClientForReply().replyWith(
            url: '${botUrl}',
            port: port,
            data: _messageData.sendMessageJSON()));
  }
}
