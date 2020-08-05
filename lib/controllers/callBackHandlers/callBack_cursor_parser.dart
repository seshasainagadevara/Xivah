import 'package:Xivah/structures/inlineKeyboards/inlinekeyboard_button.dart';

class CallbackCursorParser {
  final String cat_id;
  final String product_id;
  final String product_name;
  final num product_price;
  final num product_qty;

  CallbackCursorParser(
      {this.cat_id,
      this.product_id,
      this.product_name,
      this.product_price,
      this.product_qty});
  factory CallbackCursorParser.fromJSON(Map cursor) {
    var arr = cursor['cursor']['firstBatch'][0];
    var items = arr['items'][0];
    return CallbackCursorParser(
        cat_id: ToHexString(arr['_id']).str(),
        product_id: items['id'],
        product_name: items['name'],
        product_price: items['price'],
        product_qty: items['qty']);
  }
}
