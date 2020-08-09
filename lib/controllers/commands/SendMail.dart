import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SendMail {
  final String name, phone, date, item;
  final Map location;
  final num userId;

  SendMail(
      {this.name,
      this.phone,
      this.location,
      this.userId,
      this.date,
      this.item});
  Future<void> sendMailMe() {
    var mailId = 'vedikbharath@gmail.com';
    var pass = 'f96MBy7iz4Xq6hD';

    var addresses = ['vedikbharath@gmail.com'];

    var people = ['seshasai nagadevara'];
    print(addresses.length);
    print(people.length);
    for (int i = 0; i < addresses.length; i++) {
      _sendMail(
        mailId,
        pass,
        addresses[i],
        people[i],
      );
    }
  }

  void _sendMail(String mailId, String pass, String to, String nam) async {
    final smtp = gmail(mailId, pass);

    final message = Message()
      ..from = Address(mailId, "Bot:vedik bharath")
      ..recipients.add(to)
      ..subject = "Vedik bharath homam order"
      ..text = "An order has been placed"
      ..html = "<div><h4> ${name}</h4><br><h4>${item}</h4>"
          "<br><h3>userid:${userId}</h3><h4>location : https://www.google.com/maps/@${location['latitude']},${location['longitude']}</h4>"
          "<h4>phone: ${phone}</h4>"
          "<h4>date: ${date}</h4>"
          "</div>";

    var connection = PersistentConnection(smtp, timeout: Duration(seconds: 15));

    // Send the first message
    try {
      final sendReport = await connection.send(message);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. ${e}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    // close the connection
    await connection.close();
  }
}
