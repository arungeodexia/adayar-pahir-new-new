// To parse this JSON data, do
//
//     final groupsModelChat = groupsModelChatFromJson(jsonString);

import 'dart:convert';

GroupsModelChat groupsModelChatFromJson(String str) => GroupsModelChat.fromJson(json.decode(str));

String groupsModelChatToJson(GroupsModelChat data) => json.encode(data.toJson());

class GroupsModelChat {
  GroupsModelChat({
    this.groupId,
    this.id,
    this.message,
  });

  String? groupId;
  String? id;
  String? message;

  factory GroupsModelChat.fromJson(Map<String, dynamic> json) => GroupsModelChat(
    groupId: json["groupId"],
    id: json["id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "groupId": groupId,
    "id": id,
    "message": message,
  };
}
