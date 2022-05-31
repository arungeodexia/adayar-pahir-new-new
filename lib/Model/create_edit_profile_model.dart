

import 'dart:convert';

CreateEditProfileModel createEditProfileModelFromJson(String str) => CreateEditProfileModel.fromJson(json.decode(str));

String createEditProfileModelToJson(CreateEditProfileModel data) => json.encode(data.toJson());

class CreateEditProfileModel {

  CreateEditProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.mobile,
    this.alternativeMobile,
    this.userStatus,
    this.profilePicture,
    this.userFingerprintHash,
    this.accessToken,
    this.imeiNumber,
    this.buildNumber,
    this.appId,
    this.address1,
    this.address2,
    this.appName,
    this.skill,
    this.appVersion,
    this.deviceToken,
    this.osName,
    this.osVersion,
    this.notes,
    this.city,
    this.state,
    this.isResource,
    this.major1,
    this.major2,
    this.major1Name,
    this.major2Name,
    this.minor1,
    this.minor2,
    this.minor1Name,
    this.minor2Name,
    this.universityId,
    this.universityName,
    this.universityLogo,
    this.collegeId,
    this.collegeName,
    this.collegeLogo,
    this.year,
    this.skillTags,
    this.orgMemberId,
    this.isResoureFlag,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? alternativeMobile;
  String? userStatus;
  String? profilePicture;
  dynamic userFingerprintHash;
  dynamic accessToken;
  String? imeiNumber;
  String? buildNumber;
  String? appId;
  String? address1;
  dynamic address2;
  String? appName;
  dynamic skill;
  String? appVersion;
  String? deviceToken;
  String? osName;
  String? osVersion;
  String? notes;
  String? city;
  String? state;
  bool? isResource;
  int? major1;
  int? major2;
  String? major1Name;
  dynamic major2Name;
  int? minor1;
  int? minor2;
  dynamic minor1Name;
  dynamic minor2Name;
  int? universityId;
  String? universityName;
  String? universityLogo;
  int? collegeId;
  String? collegeName;
  String? collegeLogo;
  String? year;
  dynamic skillTags;
  int? orgMemberId;
  bool? isResoureFlag;


  factory CreateEditProfileModel.fromJson(Map<String, dynamic> json) => CreateEditProfileModel(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    countryCode: json["countryCode"],
    mobile: json["mobile"],
    alternativeMobile: json["alternativeMobile"],
    userStatus: json["userStatus"],
    profilePicture: json["profilePicture"],
    userFingerprintHash: json["userFingerprintHash"],
    accessToken: json["accessToken"],
    imeiNumber: json["imeiNumber"],
    buildNumber: json["buildNumber"],
    appId: json["appId"],
    address1: json["address1"],
    address2: json["address2"],
    appName: json["appName"],
    skill: json["skill"],
    appVersion: json["appVersion"],
    deviceToken: json["deviceToken"],
    osName: json["osName"],
    osVersion: json["osVersion"],
    notes: json["notes"],
    city: json["city"],
    state: json["state"],
    isResource: json["isResource"],
    major1: json["major1"],
    major2: json["major2"],
    major1Name: json["major1Name"],
    major2Name: json["major2Name"],
    minor1: json["minor1"],
    minor2: json["minor2"],
    minor1Name: json["minor1Name"],
    minor2Name: json["minor2Name"],
    universityId: json["universityId"],
    universityName: json["universityName"],
    universityLogo: json["universityLogo"],
    collegeId: json["collegeId"],
    collegeName: json["collegeName"],
    collegeLogo: json["collegeLogo"],
    year: json["year"],
    skillTags: json["skillTags"],
    orgMemberId: json["orgMemberId"],
    isResoureFlag: json["isResource"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "countryCode": countryCode,
    "mobile": mobile,
    "alternativeMobile": alternativeMobile,
    "userStatus": userStatus,
    "profilePicture": profilePicture,
    "userFingerprintHash": userFingerprintHash,
    "accessToken": accessToken,
    "imeiNumber": imeiNumber,
    "buildNumber": buildNumber,
    "appId": appId,
    "address1": address1,
    "address2": address2,
    "appName": appName,
    "skill": skill,
    "appVersion": appVersion,
    "deviceToken": deviceToken,
    "osName": osName,
    "osVersion": osVersion,
    "notes": notes,
    "city": city,
    "state": state,
    "isResource": isResource,
    "major1": major1,
    "major2": major2,
    "major1Name": major1Name,
    "major2Name": major2Name,
    "minor1": minor1,
    "minor2": minor2,
    "minor1Name": minor1Name,
    "minor2Name": minor2Name,
    "universityId": universityId,
    "universityName": universityName,
    "universityLogo": universityLogo,
    "collegeId": collegeId,
    "collegeName": collegeName,
    "collegeLogo": collegeLogo,
    "year": year,
    "skillTags": skillTags,
    "orgMemberId": orgMemberId,
    "isResource": isResoureFlag,
  };
}
