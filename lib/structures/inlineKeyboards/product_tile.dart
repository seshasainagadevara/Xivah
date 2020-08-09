import 'package:Xivah/structures/inlineKeyboards/RowButtons.dart';
import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';

class ProductTile {
  final Map _buttonData;
  final List<InlineKeyboardButton> _list;
  ProductTile(this._buttonData) : _list = [];

  List<InlineKeyboardButton> generateButtons() {
    return _list
        .followedBy(_buttonData['buttons']
            .map<InlineKeyboardButton>((item) => InlineKeyboardButton(
                item['text'],
                callback_data: item['data'],
                pay: item['text'].contains('Order') ? true : false))
            .toList())
//        .followedBy(_buttonData['qty']
//            .map<InlineKeyboardButton>((qt) => RowButtons(
//                text: qt['text'].toString(), callback_data: qt['data']))
//            .toList())
        .toList();
  }
}
