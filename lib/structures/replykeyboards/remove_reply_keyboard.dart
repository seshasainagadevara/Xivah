class RemoveReplyKeyboard {
  bool remove_keyboard;
  bool selective;

  RemoveReplyKeyboard(this.remove_keyboard, {this.selective});

  Map<String, bool> removeReplyKeyboard() {
    return {
      "remove_keyboard": remove_keyboard ?? true,
      "selective": selective ?? false
    };
  }
}
