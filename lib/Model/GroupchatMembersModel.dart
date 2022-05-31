// To parse this JSON data, do
//
//     final groupchatMembersModel = groupchatMembersModelFromJson(jsonString);

import 'dart:convert';

GroupchatMembersModel groupchatMembersModelFromJson(String str) => GroupchatMembersModel.fromJson(json.decode(str));

String groupchatMembersModelToJson(GroupchatMembersModel data) => json.encode(data.toJson());

class GroupchatMembersModel {
  GroupchatMembersModel({
    this.groupChatUsers,
    this.numberOfUsers,
  });

  List<GroupChatUser>? groupChatUsers;
  int? numberOfUsers;

  factory GroupchatMembersModel.fromJson(Map<String, dynamic> json) => GroupchatMembersModel(
    groupChatUsers: List<GroupChatUser>.from(json["groupChatUsers"].map((x) => GroupChatUser.fromJson(x))),
    numberOfUsers: json["numberOfUsers"],
  );

  Map<String, dynamic> toJson() => {
    "groupChatUsers": List<dynamic>.from(groupChatUsers!.map((x) => x.toJson())),
    "numberOfUsers": numberOfUsers,
  };
}

class GroupChatUser {
  GroupChatUser({
    this.id,
    this.userId,
    this.groupId,
    this.firstName,
    this.countryCode,
    this.mobileNumber,
    this.orgName,
    this.orgId,
    this.profilePictureLink,
  });

  int? id;
  int? userId;
  String? groupId;
  String? firstName;
  String? countryCode;
  String? mobileNumber;
  String? orgName;
  int? orgId;
  String? profilePictureLink;

  factory GroupChatUser.fromJson(Map<String, dynamic> json) => GroupChatUser(
    id: json["id"],
    userId: json["userId"],
    groupId: json["groupId"],
    firstName: json["firstName"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
    orgName: json["orgName"],
    orgId: json["orgId"],
    profilePictureLink: json["profilePictureLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "groupId": groupId,
    "firstName": firstName,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
    "orgName": orgName,
    "orgId": orgId,
    "profilePictureLink": profilePictureLink,
  };
}
