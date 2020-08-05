import 'package:Xivah/structures/custom_keyboard.dart';
import 'package:Xivah/structures/replykeyboards/keyboard_button.dart';

class ReplyKeyboard extends CustomKeyboard {
  List<KeyboardButtons> keyboard;
  bool resize_keyboard;
  bool one_time_keyboard;
  bool selective;

  ReplyKeyboard(this.keyboard,
      {this.resize_keyboard, this.one_time_keyboard, this.selective});

  @override
  Map<String, dynamic> sendKeyBoard() {
    return {
      'keyboard': keyboard.map((e) => [e.addKeyBoard()]).toList(),
      'resize_keyboard': resize_keyboard ?? false,
      'one_time_keyboard': one_time_keyboard ?? false,
      'selective': selective ?? false
    };
  }
}
