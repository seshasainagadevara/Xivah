import 'package:Xivah/structures/configuration_strucutre.dart';
import 'package:dotenv/dotenv.dart' show env, load, isEveryDefined;

class ServerConfig {
  ServerConfig() {
    //loads the environment file's data

    load('.env');
  }
  ConfigurationStructure startConfig() {
    // returns Configuration data
    if (isEveryDefined(
        ['SECRET_TOKEN', 'TELEGRAM_API_URL', 'SERVER_URL', 'PORT'])) {
      return ConfigurationStructure(
        token: env['SECRET_TOKEN'],
        apiUrl: env['TELEGRAM_API_URL'],
        serverUrl: env['SERVER_URL'],
        port: int.parse(env['PORT']),
      );
    }
    return null;
  }
}
