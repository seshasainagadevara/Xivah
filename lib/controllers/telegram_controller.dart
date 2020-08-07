import 'dart:io';

import 'package:Xivah/client/client_for_reply.dart';
import 'package:Xivah/controllers/callBackHandlers/Location_handler.dart';
import 'package:Xivah/controllers/post_request_processor.dart';

class TelegramController {
  final List _details;
  PostRequestProcessor _postRequestProcessor;
  LocationHandler _locationHandler;
  TelegramController(this._details) {
    _postRequestProcessor = PostRequestProcessor(_details);
    _locationHandler = LocationHandler(_details);
  }

  Future<void> processData(Map<String, dynamic> data) async {
    stdout.writeln('post request from user ===> ${data}');


    if (data.containsKey('message') && data['message'].containsKey('text')) {
      if (data['message'].containsKey('entities')) {
        data['message']['entities'].forEach((e) {
          if (e['type'].contains('bot_command')) {
            _postRequestProcessor.processBotCommand(data);
          }
        });
      } else {
        _postRequestProcessor.processNormalText(data);
      }

      //handle text data commands..

    } else if (data.containsKey('message') &&
        (data['message'].containsKey('reply_to_message') ||
            data['message'].containsKey('location'))) {
      _locationHandler.processLocation(data);
    } else if (data.containsKey('callback_query')) {
      //handle keyboard data events...
      _postRequestProcessor.processCallBackquery(data);
    }
  }
}
