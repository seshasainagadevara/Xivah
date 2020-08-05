import 'dart:io';
import 'package:Xivah/VBServerEngine/vb_server_engine.dart';
import 'package:Xivah/client/webhook_set_client.dart';
import 'package:Xivah/configuration/server_config.dart';

Future main(List<String> arguments) async {
  //get environmental variables from yaml
  var _config = ServerConfig().startConfig();
  //start server engine
  if (_config != null) {
    stdout.writeln('Server engine igniting ===>');
    //initializing
    var numOfEngines = Platform.numberOfProcessors;

    await VBServerEngine(_config.serverUrl, _config.port, numOfEngines,
            _config.token, _config.apiUrl)
        .ignite()
        .then((bool value) {
      if (value) {
        stdout.writeln(
            'Server powered🔥🔥 up with : ${numOfEngines} 😱: Engines 🔥🏎️🏎️ ');
      }
    });
    stdout.write('setting webhook ...');

    SetWebhookClient(
            port: _config.port,
            apiUrl: _config.apiUrl,
            token: _config.token,
            serverUrl: _config.serverUrl)
        .setTelegramBotWebHook();

    await ProcessSignal.sigterm.watch().first;
  }
}
