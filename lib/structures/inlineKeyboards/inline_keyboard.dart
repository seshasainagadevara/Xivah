import 'package:Xivah/structures/custom_keyboard.dart';
import 'package:Xivah/structures/inlineKeyboards/RowButtons.dart';
import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';

class InlineKeyboard extends CustomKeyboard {
  final List<InlineKeyboardButton> inlineButtons;

  InlineKeyboard(this.inlineButtons);

  @override
  Map<String, dynamic> sendKeyBoard() {
    var s = [];
    inlineButtons.removeWhere((element) {
      if (element is RowButtons) {
        s.add(element);
      }
      return element is RowButtons;
    });

    var row = [...inlineButtons, s].map((e) {
      if (e is InlineKeyboardButton) {
        return [e.createButton()];
      }
      return (e as List).map((t) => t.createButton()).toList();
    }).toList();

    return {
      'inline_keyboard': row,
    };
  }
}
