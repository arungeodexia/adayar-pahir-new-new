// To parse this JSON data, do
//
//     final privacyModel = privacyModelFromJson(jsonString);

import 'dart:convert';

PrivacyModel privacyModelFromJson(String str) => PrivacyModel.fromJson(json.decode(str));

String privacyModelToJson(PrivacyModel data) => json.encode(data.toJson());

class PrivacyModel {
  PrivacyModel({
    this.allowCall,
    this.allowSms,
    this.allowWhatsapp,
    this.allowEmail,
    this.allowCalendar,
    this.allowChat,
    this.displayPhoneNumber,
    this.allowGroup,
    this.allowClass,
  });

  bool? allowCall;
  bool? allowSms;
  bool? allowWhatsapp;
  bool? allowEmail;
  bool? allowCalendar;
  bool? allowChat;
  bool? displayPhoneNumber;
  bool? allowGroup;
  bool? allowClass;

  factory PrivacyModel.fromJson(Map<String, dynamic> json) => PrivacyModel(
    allowCall: json["allowCall"],
    allowSms: json["allowSMS"],
    allowWhatsapp: json["allowWhatsapp"],
    allowEmail: json["allowEmail"],
    allowCalendar: json["allowCalendar"],
    allowChat: json["allowChat"],
    displayPhoneNumber: json["displayPhoneNumber"],
    allowGroup: json["allowGroup"],
    allowClass: json["allowClass"],
  );

  Map<String, dynamic> toJson() => {
    "allowCall": allowCall,
    "allowSMS": allowSms,
    "allowWhatsapp": allowWhatsapp,
    "allowEmail": allowEmail,
    "allowCalendar": allowCalendar,
    "allowChat": allowChat,
    "displayPhoneNumber": displayPhoneNumber,
    "allowGroup": allowGroup,
    "allowClass": allowClass,
  };
}
