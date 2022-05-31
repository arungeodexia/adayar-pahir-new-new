// To parse this JSON data, do
//
//     final messagesModel = messagesModelFromJson(jsonString);

import 'dart:convert';

MessagesModel messagesModelFromJson(String str) => MessagesModel.fromJson(json.decode(str));

String messagesModelToJson(MessagesModel data) => json.encode(data.toJson());

class MessagesModel {
  MessagesModel({
    this.messagesCount,
    this.messages,
  });

  int? messagesCount;
  List<Message>? messages;

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
    messagesCount: json["messagesCount"],
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messagesCount": messagesCount,
    "messages": List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.messageId,
    this.orgId,
    this.orgName,
    this.orgLogo,
    this.orgChannelId,
    this.orgMemberId,
    this.status,
    this.orgChannelName,
    this.orgChannelLogo,
    this.messageIcon,
    this.messageTitle,
    this.messageBody,
    this.contentId,
    this.sentDate,
    this.expiryDate,
    this.createdDate,
    this.updatedDate,
    this.messageReaction,
  });

  int? messageId;
  int? orgId;
  String? orgName;
  String? orgLogo;
  int? orgChannelId;
  int? orgMemberId;
  String? status;
  String? orgChannelName;
  String? orgChannelLogo;
  String? messageIcon;
  String? messageTitle;
  MessageBody? messageBody;
  int? contentId;
  DateTime? sentDate;
  DateTime? expiryDate;
  DateTime? createdDate;
  DateTime? updatedDate;
  MessageReaction? messageReaction;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    messageId: json["messageId"],
    orgId: json["orgId"],
    orgName: json["orgName"],
    orgLogo: json["orgLogo"],
    orgChannelId: json["orgChannelId"],
    orgMemberId: json["orgMemberId"],
    status: json["status"],
    orgChannelName: json["orgChannelName"],
    orgChannelLogo: json["orgChannelLogo"],
    messageIcon: json["messageIcon"],
    messageTitle: json["messageTitle"],
    messageBody: MessageBody.fromJson(json["messageBody"]),
    contentId: json["contentId"],
    sentDate: DateTime.parse(json["sentDate"]),
    expiryDate: DateTime.parse(json["expiryDate"]),
    createdDate: DateTime.parse(json["createdDate"]),
    updatedDate: DateTime.parse(json["updatedDate"]),
    messageReaction: MessageReaction.fromJson(json["messageReaction"]),
  );

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "orgId": orgId,
    "orgName": orgName,
    "orgLogo": orgLogo,
    "orgChannelId": orgChannelId,
    "orgMemberId": orgMemberId,
    "status": status,
    "orgChannelName": orgChannelName,
    "orgChannelLogo": orgChannelLogo,
    "messageIcon": messageIcon,
    "messageTitle": messageTitle,
    "messageBody": messageBody!.toJson(),
    "contentId": contentId,
    "sentDate": sentDate!.toIso8601String(),
    "expiryDate": "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "createdDate": createdDate!.toIso8601String(),
    "updatedDate": updatedDate!.toIso8601String(),
    "messageReaction": messageReaction!.toJson(),
  };
}

class MessageBody {
  MessageBody({
    this.orgName,
    this.orgLogo,
    this.contentUri,
    this.messageId,
    this.messageTitle,
    this.contentTitle,
    this.messageSent,
    this.message,
    this.contentType,
  });

  dynamic orgName;
  dynamic orgLogo;
  String? contentUri;
  int? messageId;
  String? messageTitle;
  String? contentTitle;
  dynamic messageSent;
  dynamic message;
  String? contentType;

  factory MessageBody.fromJson(Map<String, dynamic> json) => MessageBody(
    orgName: json["orgName"],
    orgLogo: json["orgLogo"],
    contentUri: json["contentURI"],
    messageId: json["messageId"],
    messageTitle: json["messageTitle"],
    contentTitle: json["contentTitle"],
    messageSent: json["messageSent"],
    message: json["message"],
    contentType: json["contentType"],
  );

  Map<String, dynamic> toJson() => {
    "orgName": orgName,
    "orgLogo": orgLogo,
    "contentURI": contentUri,
    "messageId": messageId,
    "messageTitle": messageTitle,
    "contentTitle": contentTitle,
    "messageSent": messageSent,
    "message": message,
    "contentType": contentType,
  };
}

class MessageReaction {
  MessageReaction({
    this.selectedReactionId,
    this.selectedReactionName,
    this.numberOfReactions,
  });

  int? selectedReactionId;
  String? selectedReactionName;
  List<NumberOfReaction>? numberOfReactions;

  factory MessageReaction.fromJson(Map<String, dynamic> json) => MessageReaction(
    selectedReactionId: json["selectedReactionId"],
    selectedReactionName: json["selectedReactionName"] == null ? null : json["selectedReactionName"],
    numberOfReactions: List<NumberOfReaction>.from(json["numberOfReactions"].map((x) => NumberOfReaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "selectedReactionId": selectedReactionId,
    "selectedReactionName": selectedReactionName == null ? null : selectedReactionName,
    "numberOfReactions": List<dynamic>.from(numberOfReactions!.map((x) => x.toJson())),
  };
}

class NumberOfReaction {
  NumberOfReaction({
    this.messageReactionId,
    this.messageReactionName,
    this.messageReactionCount,
  });

  int? messageReactionId;
  String? messageReactionName;
  int? messageReactionCount;

  factory NumberOfReaction.fromJson(Map<String, dynamic> json) => NumberOfReaction(
    messageReactionId: json["messageReactionId"],
    messageReactionName: json["messageReactionName"],
    messageReactionCount: json["messageReactionCount"],
  );

  Map<String, dynamic> toJson() => {
    "messageReactionId": messageReactionId,
    "messageReactionName": messageReactionName,
    "messageReactionCount": messageReactionCount,
  };
}
