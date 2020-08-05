import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:Xivah/VBServerEngine/server_engine.dart';

class VBServerEngine {
  String host = InternetAddress.loopbackIPv4.host;
  final int port;
  final int numofEngines;
  final String token, apiUrl;

  VBServerEngine(
      this.host, this.port, this.numofEngines, this.token, this.apiUrl);

  Future<bool> ignite() async {
    for (num i = 0; i < numofEngines; ++i) {
      await Isolate.spawn(ServerEngine.startEngine, [port, token, apiUrl]);
    }
    return true;
  }
}
