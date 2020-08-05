import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';

class ProductsParserModel {
  final String text;

  final List<InlineKeyboardButton> buttons;
  ProductsParserModel({this.text, this.buttons});
  factory ProductsParserModel.fromJson(Map json) {
    return ProductsParserModel(
        text: json['name'],
        buttons: json['items']
            .map<InlineKeyboardButton>(
                (item) => InlineKeyboardButton.ItemFromJson(item, json['_id']))
            .toList());
  }
}
