import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/callBackHandlers/callBack_cursor_parser.dart';
import 'package:Xivah/controllers/database/database_connection.dart';
import 'package:Xivah/controllers/replySender.dart';
import 'package:Xivah/structures/inlineKeyboards/product_tile.dart';
import 'package:Xivah/structures/inlineKeyboards/products_parser_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CategoryCallbackHandler {
  final String _id;
  String _botUrl;
  num chatId, msgId, port;
  DatabaseConnect _databaseConnect;

  CategoryCallbackHandler(
      this._id, this._botUrl, this.chatId, this.msgId, this.port) {
    _databaseConnect = DatabaseConnect();
  }

  void processCategories() async {
    await _databaseConnect.openDBConnection().then((database) async {
      if (database != null) {
        await database
            .collection('categories')
            .findOne(where.id(ObjectId.fromHexString(_id)))
            .then((object) => ProductsParserModel.fromJson(object))
            .then((value) async => await ReplySender(
                    port: port,
                    chatId: chatId,
                    botUrl: _botUrl,
                    text: '${value.text}',
                    buttons: value.buttons)
                .sendReply())
            .then((value) async { await ClientForReply().replyWith(
                url: '${_botUrl}/deleteMessage',
                port: port,
                data: {'chat_id': chatId, 'message_id': msgId});
            })
            .catchError(
                (error) => print('error at category_handler: ${error}'));
        await database.close();
      }
    });
  }

  void processItems(
      {String itemId, num qty = 1, String type = '', num senderId}) async {
    await ClientForReply().replyWith(
        url: '${_botUrl}/deleteMessage',
        port: port,
        data: {'chat_id': chatId, 'message_id': msgId});
    await _databaseConnect.openDBConnection().then((database) async {
      if (database != null) {
        await database.collection('categories').aggregate([
          {
            '\$match': {'_id': ObjectId.fromHexString(_id), 'items.id': itemId}
          },
          {
            '\$project': {
              'items': {
                '\$filter': {
                  'input': '\$items',
                  'as': 'item',
                  'cond': {
                    '\$eq': ['\$\$item.id', itemId]
                  }
                }
              }
            }
          }
        ], cursor: {
          'batchSize': 1
        }).then((cursor) async {

          var _product = CallbackCursorParser.fromJSON(cursor);
          if (type.contains('buy')) {
            await database.collection('people').update(
                where.eq('userId', senderId),
                modify.push('orders', {
                  'order_items': [
                    {
                      'item': _product.product_name,
                      'price': _product.product_price,
                    }
                  ],
                  'order_date': DateTime.now().toIso8601String(),
                  'order_total': _product.product_price,
                  'payment': 'offline'
                })).then((value) async{
                 await database.collection('orders').insert({
                    'userId': senderId,
                    'orderItem': _product.product_name,
                    'price': _product.product_price,
                    'phone':'',
                    'priests':_product.priests,

                  });
            }).catchError((e)=> print("error storing data"));
          } else {
            var product_buttons = {
              'buttons': [
                {
                  'text': 'Order now',
                  'data': 'buy:${_product.cat_id}:${_product.product_id}'
                },
//              {
//                'text': 'Add to cart',
//                'data': 'add:${_product.cat_id}:${_product.product_id}'
//              },
                {'text': 'Menu', 'data': 'categories:${_product.cat_id}'},
              ],
//            'qty': List.generate(
//                5,
//                (index) => {
//                      'text': index + 1,
//                      'data':
//                          'qty:${_product.cat_id}:${_product.product_id}:${index + 1}'
//                    })
            };

            await ReplySender(
                    port: port,
                    chatId: chatId,
                    botUrl: _botUrl,
                    text:
                        "<strong> <u>${_product.product_name}.</u></strong> \n\n"
                        "  ${_product.description.padLeft(10, '  ')}\n\n"
                        "<b>Duration: ${_product.duration} Hours.</b>\n\n"
                        "<b>Priests: ${_product.priests}.</b>\n\n"
                        "<b><i>Rs. ${_product.product_price}/- </i></b>\n",
//                      "<b><i>Rs. ${_product.product_price * qty}/- </i></b>\n",
//                      "Quantity: ${_product.product_qty*qty} \n"
//                      "You could also choose quantity 🔢",
                    buttons: ProductTile(product_buttons).generateButtons())
                .sendReply();
          }
        }).catchError((error) => print('error at category_handler: ${error}'));
        await database.close();
      }
    });
  }
}
