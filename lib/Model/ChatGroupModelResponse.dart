// To parse this JSON data, do
//
//     final chatGroupModelResponse = chatGroupModelResponseFromJson(jsonString);

import 'dart:convert';

ChatGroupModelResponse chatGroupModelResponseFromJson(String str) => ChatGroupModelResponse.fromJson(json.decode(str));

String chatGroupModelResponseToJson(ChatGroupModelResponse data) => json.encode(data.toJson());

class ChatGroupModelResponse {
  ChatGroupModelResponse({
    this.id,
    this.groupId,
    this.message,
  });

  int? id;
  String? groupId;
  String? message;

  factory ChatGroupModelResponse.fromJson(Map<String, dynamic> json) => ChatGroupModelResponse(
    id: json["id"],
    groupId: json["groupId"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupId": groupId,
    "message": message,
  };
}
