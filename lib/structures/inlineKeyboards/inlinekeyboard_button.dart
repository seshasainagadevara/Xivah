import 'package:mongo_dart/mongo_dart.dart';

class InlineKeyboardButton {
  final String text;
  final String callback_data;
  final String switch_inline_query_current_chat;
  final bool pay;

  InlineKeyboardButton(this.text,
      {this.callback_data, this.pay, this.switch_inline_query_current_chat});

  factory InlineKeyboardButton.categoryFromJson(Map json, {String addition}) {
    return InlineKeyboardButton(
      json['name'] as String,
      callback_data: '$addition:${(json['_id'] as ObjectId).str()}',
    );
  }

  factory InlineKeyboardButton.ItemFromJson(Map json, ObjectId id) {
    return InlineKeyboardButton('${json['name']}   Rs.${json['price']}/-',
        callback_data: '${id.str()}:${json['id']}');
  }







  Map<String, dynamic> createButton() {
    return {
      "text": text,
      "callback_data": callback_data,
      "switch_inline_query_current_chat": switch_inline_query_current_chat,
      "pay": pay
    };
  }
}

extension ToHexString on ObjectId {
  String str() => this.toHexString();
}

extension ToObjectId on String {
  ObjectId toId(str) => ObjectId.fromHexString(str);
}
