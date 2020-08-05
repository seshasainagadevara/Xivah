
import 'package:Xivah/configuration/databaseConfig/databaseConnection.dart';
import 'package:Xivah/controllers/database/database_connection.dart';

class QtyStore{
  DataBaseConnectionConfig _baseConnectionConfig;
  DatabaseConnect _databaseConnect;
  QtyStore(){
    _baseConnectionConfig = DataBaseConnectionConfig();
    _databaseConnect = DatabaseConnect();
  }

  storeQty(num qty, ){


}
deStoreQty(){

}
}