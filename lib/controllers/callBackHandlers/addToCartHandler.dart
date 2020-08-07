//import 'package:Xivah/controllers/database/database_connection.dart';
//import 'package:mongo_dart/mongo_dart.dart';
//
//class AddToCartHandler {
//  final String catId, productId;
//  final num userId;
//  DatabaseConnect _databaseConnect;
//
//  AddToCartHandler({this.userId, this.catId, this.productId}) {
//    _databaseConnect = DatabaseConnect();
//  }
//
//  addToCart() {
//    //clear cart
//    // fetch category details and update the details according to user cache_area
//    // then reset cache_area to 1
//    // then insert modified document to user kart
//    _databaseConnect.openDBConnection().then((database) {
//      if (database != null) {
//        database
//            .collection('people')
//            .findOne(
//                where.eq('userId', userId).fields(['modified', 'cache_area']))
//            .then((value) => print(value));
//      }
//    });
//  }
//}
