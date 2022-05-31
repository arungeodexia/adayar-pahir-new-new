// To parse this JSON data, do
//
//     final contentModel = contentModelFromJson(jsonString);

import 'dart:convert';

ContentModel contentModelFromJson(String str) => ContentModel.fromJson(json.decode(str));

String contentModelToJson(ContentModel data) => json.encode(data.toJson());

class ContentModel {
  ContentModel({
    this.contentAuthor,
    this.contentBusinessSector,
    this.contentCategory,
    this.contentDescription,
    this.contentFileName,
    this.contentFileType,
    this.contentId,
    this.contentLanguage,
    this.contentNotes,
    this.contentRank,
    this.contentStatus,
    this.contentTag,
    this.contentTitle,
    this.contentUri,
    this.contentUploadDate,
    this.contentVersion,
    this.orgChannelIds,
    this.userId,
    this.userName,
  });

  String? contentAuthor;
  String? contentBusinessSector;
  String? contentCategory;
  String? contentDescription;
  String? contentFileName;
  String? contentFileType;
  int? contentId;
  String? contentLanguage;
  String? contentNotes;
  String? contentRank;
  String? contentStatus;
  String? contentTag;
  String? contentTitle;
  String? contentUri;
  String? contentUploadDate;
  String? contentVersion;
  List<int>? orgChannelIds;
  int? userId;
  String? userName;

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
    contentAuthor: json["contentAuthor"],
    contentBusinessSector: json["contentBusinessSector"],
    contentCategory: json["contentCategory"],
    contentDescription: json["contentDescription"],
    contentFileName: json["contentFileName"],
    contentFileType: json["contentFileType"],
    contentId: json["contentId"],
    contentLanguage: json["contentLanguage"],
    contentNotes: json["contentNotes"],
    contentRank: json["contentRank"],
    contentStatus: json["contentStatus"],
    contentTag: json["contentTag"],
    contentTitle: json["contentTitle"],
    contentUri: json["contentURI"],
    contentUploadDate: json["contentUploadDate"],
    contentVersion: json["contentVersion"],
    orgChannelIds: List<int>.from(json["orgChannelIds"].map((x) => x)),
    userId: json["userId"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "contentAuthor": contentAuthor,
    "contentBusinessSector": contentBusinessSector,
    "contentCategory": contentCategory,
    "contentDescription": contentDescription,
    "contentFileName": contentFileName,
    "contentFileType": contentFileType,
    "contentId": contentId,
    "contentLanguage": contentLanguage,
    "contentNotes": contentNotes,
    "contentRank": contentRank,
    "contentStatus": contentStatus,
    "contentTag": contentTag,
    "contentTitle": contentTitle,
    "contentURI": contentUri,
    "contentUploadDate": contentUploadDate,
    "contentVersion": contentVersion,
    "orgChannelIds": List<dynamic>.from(orgChannelIds!.map((x) => x)),
    "userId": userId,
    "userName": userName,
  };
}
