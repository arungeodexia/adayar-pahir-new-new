// To parse this JSON data, do
//
//     final addchatnewModel = addchatnewModelFromJson(jsonString);

import 'dart:convert';

AddchatnewModel addchatnewModelFromJson(String str) => AddchatnewModel.fromJson(json.decode(str));

String addchatnewModelToJson(AddchatnewModel data) => json.encode(data.toJson());

class AddchatnewModel {
  AddchatnewModel({
    this.membersCount,
    this.nextStart,
    this.lastPage,
    this.members,
  });

  int? membersCount;
  int? nextStart;
  bool? lastPage;
  List<Member>? members;

  factory AddchatnewModel.fromJson(Map<String, dynamic> json) => AddchatnewModel(
    membersCount: json["membersCount"],
    nextStart: json["nextStart"],
    lastPage: json["lastPage"],
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "membersCount": membersCount,
    "nextStart": nextStart,
    "lastPage": lastPage,
    "members": List<dynamic>.from(members!.map((x) => x.toJson())),
  };
}

class Member {
  Member({
    this.name,
    this.countryCode,
    this.mobileNumber,
    this.profilePicture,
    this.orgMemberId,
    this.userId,
    this.major,
    this.majorId,
    this.year,
    this.groupName,
    this.groupIcon,
    this.groupId,
    this.orgMemberChannelId,
    this.alreadyInChatGroup,
    this.chatGroupId,
  });

  String? name;
  String? countryCode;
  String? mobileNumber;
  String? profilePicture;
  int? orgMemberId;
  int? userId;
  String? major;
  int? majorId;
  String? year;
  String? groupName;
  String? groupIcon;
  int? groupId;
  int? orgMemberChannelId;
  bool? alreadyInChatGroup;
  String? chatGroupId;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    name: json["name"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
    profilePicture: json["profilePicture"],
    orgMemberId: json["orgMemberId"],
    userId: json["userId"],
    major: json["major"],
    majorId: json["majorId"],
    year: json["year"],
    groupName: json["groupName"],
    groupIcon: json["groupIcon"],
    groupId: json["groupId"],
    orgMemberChannelId: json["orgMemberChannelId"],
    alreadyInChatGroup: json["alreadyInChatGroup"],
    chatGroupId: json["chatGroupId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
    "profilePicture": profilePicture,
    "orgMemberId": orgMemberId,
    "userId": userId,
    "major": major,
    "majorId": majorId,
    "year": year,
    "groupName": groupName,
    "groupIcon": groupIcon,
    "groupId": groupId,
    "orgMemberChannelId": orgMemberChannelId,
    "alreadyInChatGroup": alreadyInChatGroup,
    "chatGroupId": chatGroupId,
  };
}
