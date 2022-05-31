// To parse this JSON data, do
//
//     final resources = resourcesFromJson(jsonString);

import 'dart:convert';

List<Resources> resourcesFromJson(String str) => List<Resources>.from(json.decode(str).map((x) => Resources.fromJson(x)));

String resourcesToJson(List<Resources> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Resources {
  Resources({
    this.id,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.gender,
    this.level,
    this.sharedByUserId,
    this.countryCode,
    this.mobile,
    this.city,
    this.state,
    this.country,
    this.skillId,
    this.skill,
    this.profilePicture,
    this.favorite,
    this.createdDate,
    this.rating,
    this.review,
    this.ratingDate,
    this.notes,
    this.notesDate,
    this.userFingerprintHash,
    this.accessToken,
    this.sharedDetails,
    this.resourceStatus,
    this.imeiNumber,
    this.buildNumber,
    this.appVersion,
    this.osName,
    this.osVersion,
    this.isMyResource,
    this.skillTags,
    this.resourceType,
  });

  String? id;
  int? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  dynamic gender;
  dynamic level;
  int? sharedByUserId;
  String? countryCode;
  String? mobile;
  String? city;
  String? state;
  dynamic country;
  int? skillId;
  String? skill;
  String? profilePicture;
  int? favorite;
  String? createdDate;
  int? rating;
  dynamic review;
  String? ratingDate;
  String? notes;
  String? notesDate;
  dynamic userFingerprintHash;
  dynamic accessToken;
  dynamic sharedDetails;
  dynamic resourceStatus;
  dynamic imeiNumber;
  dynamic buildNumber;
  dynamic appVersion;
  dynamic osName;
  dynamic osVersion;
  bool? isMyResource;
  String? skillTags;
  dynamic resourceType;

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
    id: json["id"],
    userId: json["userId"],
    firstName: json["firstName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    lastName: json["lastName"],
    email: json["email"],
    gender: json["gender"],
    level: json["level"],
    sharedByUserId: json["sharedByUserId"],
    countryCode: json["countryCode"],
    mobile: json["mobile"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    skillId: json["skill_id"],
    skill: json["skill"],
    profilePicture: json["profilePicture"] == null ? null : json["profilePicture"],
    favorite: json["favorite"],
    createdDate: json["createdDate"],
    rating: json["rating"],
    review: json["review"],
    ratingDate: json["rating_date"],
    notes: json["notes"],
    notesDate: json["notes_date"],
    userFingerprintHash: json["userFingerprintHash"],
    accessToken: json["accessToken"],
    sharedDetails: json["sharedDetails"],
    resourceStatus: json["resourceStatus"],
    imeiNumber: json["imeiNumber"],
    buildNumber: json["buildNumber"],
    appVersion: json["appVersion"],
    osName: json["osName"],
    osVersion: json["osVersion"],
    isMyResource: json["isMyResource"],
    skillTags: json["skillTags"],
    resourceType: json["resourceType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "firstName": firstName,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName,
    "email": email,
    "gender": gender,
    "level": level,
    "sharedByUserId": sharedByUserId,
    "countryCode": countryCode,
    "mobile": mobile,
    "city": city,
    "state": state,
    "country": country,
    "skill_id": skillId,
    "skill": skill,
    "profilePicture": profilePicture == null ? null : profilePicture,
    "favorite": favorite,
    "createdDate": createdDate,
    "rating": rating,
    "review": review,
    "rating_date": ratingDate,
    "notes": notes,
    "notes_date": notesDate,
    "userFingerprintHash": userFingerprintHash,
    "accessToken": accessToken,
    "sharedDetails": sharedDetails,
    "resourceStatus": resourceStatus,
    "imeiNumber": imeiNumber,
    "buildNumber": buildNumber,
    "appVersion": appVersion,
    "osName": osName,
    "osVersion": osVersion,
    "isMyResource": isMyResource,
    "skillTags": skillTags,
    "resourceType": resourceType,
  };
}
