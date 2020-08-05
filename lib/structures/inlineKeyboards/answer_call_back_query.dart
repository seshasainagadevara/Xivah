class AnswerCallBackQuery {
  String callback_query_id;
  String text;
  bool show_alert;
  num cache_time;

  AnswerCallBackQuery(this.callback_query_id,
      {this.cache_time, this.show_alert, this.text});

  Map<String, dynamic> answerQuery() {
    try {
      return {
        "callback_query_id": callback_query_id,
        "text": text,
        "show_alert": show_alert,
        "cache_time": cache_time,
      };
    } catch (e) {
      print("exception at answerquery model:${e}");
    }
  }
}
