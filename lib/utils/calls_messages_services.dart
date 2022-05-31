import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
 static void call(String number) => launch("tel:$number");
 static void sendSms(String number) => launch("sms:$number");
 static void sendEmail(String email) => launch("mailto:$email");
}
const ktextstyle= TextStyle(
    fontFamily: "OpenSans",
    fontSize: 14,
    fontWeight: FontWeight.bold);
