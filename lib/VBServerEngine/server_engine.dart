import 'dart:convert';
import 'dart:io';

import 'package:Xivah/controllers/telegram_controller.dart';

class ServerEngine {
  static final String _host = InternetAddress.loopbackIPv4.host;

  static startEngine(List<dynamic> details) async {
    //server start
    var server = await HttpServer.bind(_host, details[0], shared: true);

    await for (var request in server) {
      //request.listen((event) => print);
      var response = request.response;

      var contentType = request.headers.contentType;

      var routeCheck = List.from(request.requestedUri.pathSegments)
          .join('/')
          .contains('${details[1]}/t1');

      if (request.method == 'POST' && routeCheck) {
        if (contentType?.mimeType == 'application/json') {
          try {
            var content = await utf8.decoder.bind(request).join();
            var data = jsonDecode(content) as Map;
            Future.delayed(
                const Duration(
                  milliseconds: 200,
                ),
                () => TelegramController(details).processData(data));
            response..statusCode = HttpStatus.ok;
            await response.close();
          } catch (e) {
            stdout.writeln(e);
            response..statusCode = HttpStatus.internalServerError;
          }
        } else {
          response..statusCode = HttpStatus.methodNotAllowed;
        }
      }

      await response.close();
    }
  }
}
