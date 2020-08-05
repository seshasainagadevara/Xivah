import 'package:dotenv/dotenv.dart' show load, isEveryDefined, env;

class DataBaseConnectionConfig {
  String dataB;
  int DBport;
  String HOST;

  DataBaseConnectionConfig() {
    load('.env');
    if (isEveryDefined(['dataB', 'DBport', 'HOST'])) {
      dataB = env['dataB'];
      DBport = int.parse(env['DBport']);
      HOST = env['HOST'];
    }
  }
}
