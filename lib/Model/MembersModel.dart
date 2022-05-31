// To parse this JSON data, do
//
//     final membersModel = membersModelFromJson(jsonString);

import 'dart:convert';

MembersModel membersModelFromJson(String str) => MembersModel.fromJson(json.decode(str));

String membersModelToJson(MembersModel data) => json.encode(data.toJson());

class MembersModel {
  MembersModel({
    this.orgMembers,
    this.orgMembersCount,
  });

  List<OrgMember>? orgMembers;
  int? orgMembersCount;

  factory MembersModel.fromJson(Map<String, dynamic> json) => MembersModel(
    orgMembers: List<OrgMember>.from(json["orgMembers"].map((x) => OrgMember.fromJson(x))),
    orgMembersCount: json["orgMembersCount"],
  );

  Map<String, dynamic> toJson() => {
    "orgMembers": List<dynamic>.from(orgMembers!.map((x) => x.toJson())),
    "orgMembersCount": orgMembersCount,
  };
}

class OrgMember {
  OrgMember({
    this.orgChannelMemberId,
    this.orgMemberId,
    this.userId,
    this.orgId,
    this.orgChannelId,
    this.skillId,
    this.skillName,
    this.skillAlias,
    this.countryCode,
    this.mobileNumber,
    this.mobileNumberStatus,
    this.alternativeNumber,
    this.professionalInfo,
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.state,
    this.country,
    this.userStatus,
    this.email,
    this.emailStatus,
    this.gender,
    this.notes,
    this.language,
    this.profilePictureLink,
    this.subscriptionLevel,
    this.effectiveStartDate,
    this.effectiveEndDate,
  });

  int? orgChannelMemberId;
  int? orgMemberId;
  int? userId;
  int? orgId;
  int? orgChannelId;
  int? skillId;
  dynamic skillName;
  dynamic skillAlias;
  String? countryCode;
  String? mobileNumber;
  String?  mobileNumberStatus;
  String? alternativeNumber;
  dynamic professionalInfo;
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  dynamic address3;
  String? city;
  String? state;
  String? country;
  String? userStatus;
  String? email;
  String? emailStatus;
  dynamic gender;
  String? notes;
  String? language;
  String? profilePictureLink;
  dynamic subscriptionLevel;
  DateTime? effectiveStartDate;
  DateTime? effectiveEndDate;


  factory OrgMember.fromJson(Map<String, dynamic> json) => OrgMember(
    orgChannelMemberId: json["orgChannelMemberId"],
    orgMemberId: json["orgMemberId"],
    userId: json["userId"],
    orgId: json["orgId"],
    orgChannelId: json["orgChannelId"],
    skillId: json["skillId"],
    skillName: json["skillName"],
    skillAlias: json["skillAlias"],
    countryCode: json["countryCode"],
    mobileNumber: json["mobileNumber"],
    mobileNumberStatus: json["mobileNumberStatus"],
    alternativeNumber: json["alternativeNumber"] == null ? null : json["alternativeNumber"],
    professionalInfo: json["professionalInfo"],
    firstName: json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    address1: json["address1"] == null ? null : json["address1"],
    address2: json["address2"] == null ? null : json["address2"],
    address3: json["address3"],
    city: json["city"],
    state: json["state"],
    country: json["country"] == null ? null : json["country"],
    userStatus: json["userStatus"],
    email: json["email"] == null ? null : json["email"],
    emailStatus: json["emailStatus"],
    gender: json["gender"],
    notes: json["notes"] == null ? null : json["notes"],
    language: json["language"] == null ? null : json["language"],
    profilePictureLink: json["profilePictureLink"] == null ? null : json["profilePictureLink"],
    subscriptionLevel: json["subscriptionLevel"],
    effectiveStartDate: DateTime.parse(json["effectiveStartDate"]),
    effectiveEndDate: DateTime.parse(json["effectiveEndDate"]),
  );

  Map<String, dynamic> toJson() => {
    "orgChannelMemberId": orgChannelMemberId,
    "orgMemberId": orgMemberId,
    "userId": userId,
    "orgId": orgId,
    "orgChannelId": orgChannelId,
    "skillId": skillId,
    "skillName": skillName,
    "skillAlias": skillAlias,
    "countryCode": countryCode,
    "mobileNumber": mobileNumber,
    "mobileNumberStatus": mobileNumberStatus,
    "alternativeNumber": alternativeNumber == null ? null : alternativeNumber,
    "professionalInfo": professionalInfo,
    "firstName": firstName,
    "lastName": lastName == null ? null : lastName,
    "address1": address1 == null ? null : address1,
    "address2": address2 == null ? null : address2,
    "address3": address3,
    "city": city,
    "state": state,
    "country": country == null ? null : country,
    "userStatus": userStatus,
    "email": email == null ? null : email,
    "emailStatus": emailStatus,
    "gender": gender,
    "notes": notes == null ? null : notes,
    "language": language == null ? null : language,
    "profilePictureLink": profilePictureLink == null ? null : profilePictureLink,
    "subscriptionLevel": subscriptionLevel,
    "effectiveStartDate": "${effectiveStartDate!.year.toString().padLeft(4, '0')}-${effectiveStartDate!.month.toString().padLeft(2, '0')}-${effectiveStartDate!.day.toString().padLeft(2, '0')}",
    "effectiveEndDate": "${effectiveEndDate!.year.toString().padLeft(4, '0')}-${effectiveEndDate!.month.toString().padLeft(2, '0')}-${effectiveEndDate!.day.toString().padLeft(2, '0')}",
  };
}
