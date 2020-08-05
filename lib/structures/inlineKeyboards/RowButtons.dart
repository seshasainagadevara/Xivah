import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';

class RowButtons extends InlineKeyboardButton {
  @override
  final String text;
  @override
  final String callback_data;
  RowButtons({this.text, this.callback_data})
      : super(text, callback_data: callback_data);
}
