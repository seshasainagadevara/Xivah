import 'dart:convert';
import 'dart:io';

class ClientForReply {
  HttpClient _httpClient;

  ClientForReply()
      : _httpClient = HttpClient(context: SecurityContext.defaultContext);

  Future<void> replyWith({String url, Map data, int port}) async {
    try {
      var _httpClientRequest = await _httpClient.postUrl(Uri.parse(url))
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(data));

      var _response = await _httpClientRequest.close();

      if (_response.statusCode == 200) {
        _response.transform(utf8.decoder).listen((event) async {
          // print("response for our client req=====> $event");

//do something
        }).onDone(() => _httpClient.close());
      }
    } catch (e) {
      stdout.writeln("error at reply client try:===>:$e");
    }
    return;
  }
}
