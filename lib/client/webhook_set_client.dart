import 'dart:convert';
import 'dart:io';

class SetWebhookClient {
  String _baseUrl, _getWebhookUrl, _setWebhookUrl, _deleteWebhookUrl;
  final String apiUrl, token, serverUrl;
  num port;
  HttpClient _httpClient;
  SetWebhookClient({this.port, this.apiUrl, this.token, this.serverUrl}) {
    _httpClient = HttpClient(context: SecurityContext.defaultContext);
    //base url for telegram api
    _baseUrl = "${apiUrl}bot${token}";

    //get webhook method
    _getWebhookUrl = "${_baseUrl}/getWebhookInfo";

    //set webhook api method
    _setWebhookUrl =
        "${_baseUrl}/setWebhook?url=${serverUrl}${token}/t1&max_connections=60";

    //delete webhook api method
    _deleteWebhookUrl = "${_baseUrl}/deleteWebhook";
  }

  void setTelegramBotWebHook() async {
    try {
      HttpClientRequest _httpClientRequest =
          await _httpClient.postUrl(Uri.parse(_getWebhookUrl));

      HttpClientResponse _response = await _httpClientRequest.close();

      if (_response.statusCode == 200) {
        _response.transform(utf8.decoder).listen((event) async {
          final Map<String, dynamic> respBody =
              jsonDecode(event) as Map<String, dynamic>;
          print("response: ${respBody}");
          if (respBody['ok'] == true &&
              (respBody['result']['url'] as String)
                  .contains("${serverUrl}${token}/t1")) {
            print("webhook is correct ");
          } else {
            _httpClient
                .postUrl(Uri.parse(_deleteWebhookUrl))
                .then((value) async => await value.close())
                .then((value) async {
              if (value.statusCode == 200) {
                _httpClient
                    .postUrl(Uri.parse(_setWebhookUrl))
                    .then((value) async => await value.close())
                    .then((value) {
                  if (value.statusCode == 200) {
                    value
                        .transform(utf8.decoder)
                        .listen((event) => stdout.writeln(event))
                        .onDone(() => _httpClient.close());
                  }
                });
              }
            }).catchError((e) {
              stdout.writeln("error:===>:$e");
              _httpClient.close();
            });
          }
        });
      }
    } catch (e) {
      _httpClient.close();
      stdout.writeln("error at client try:===>:$e");
    }
  }
}
