class KeyboardButtons {
  String text;
  bool request_contact;
  bool request_location;
  KeyboardButtons(this.text, {this.request_contact, this.request_location});

  Map<String, dynamic> addKeyBoard() {
    return {
      "text": text,
      "request_contact": request_contact ?? false,
      "request_location": request_location ?? false
    };
  }
}
