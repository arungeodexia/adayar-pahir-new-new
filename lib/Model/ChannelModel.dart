// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

ChannelModel channelModelFromJson(String str) => ChannelModel.fromJson(json.decode(str));

String channelModelToJson(ChannelModel data) => json.encode(data.toJson());

class ChannelModel {
  ChannelModel({
    this.orgChannels,
  });

  List<OrgChannel>? orgChannels;

  factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
    orgChannels: List<OrgChannel>.from(json["orgChannels"].map((x) => OrgChannel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orgChannels": List<dynamic>.from(orgChannels!.map((x) => x.toJson())),
  };
}

class OrgChannel {
  OrgChannel({
    this.orgChannelId,
    this.orgChannelName,
    this.orgChannelDescription,
    this.orgChannelIcon,
    this.orgId,
    this.orgName,
    this.status,
    this.showRating,
    this.channelCreatedBy,
    this.channelLastUpdatedBy,
    this.effectiveStartDate,
    this.effectiveEndDate,
  });

  int? orgChannelId;
  String? orgChannelName;
  String? orgChannelDescription;
  String? orgChannelIcon;
  int? orgId;
  String? orgName;
  String? status;
  int? showRating;
  String? channelCreatedBy;
  String? channelLastUpdatedBy;
  DateTime? effectiveStartDate;
  DateTime? effectiveEndDate;

  factory OrgChannel.fromJson(Map<String, dynamic> json) => OrgChannel(
    orgChannelId: json["orgChannelId"],
    orgChannelName: json["orgChannelName"],
    orgChannelDescription: json["orgChannelDescription"],
    orgChannelIcon: json["orgChannelIcon"],
    orgId: json["orgId"],
    orgName: json["orgName"],
    status: json["status"],
    showRating: json["showRating"],
    channelCreatedBy: json["channelCreatedBy"],
    channelLastUpdatedBy: json["channelLastUpdatedBy"],
    effectiveStartDate: DateTime.parse(json["effectiveStartDate"]),
    effectiveEndDate: DateTime.parse(json["effectiveEndDate"]),
  );

  Map<String, dynamic> toJson() => {
    "orgChannelId": orgChannelId,
    "orgChannelName": orgChannelName,
    "orgChannelDescription": orgChannelDescription,
    "orgChannelIcon": orgChannelIcon,
    "orgId": orgId,
    "orgName": orgName,
    "status": status,
    "showRating": showRating,
    "channelCreatedBy": channelCreatedBy,
    "channelLastUpdatedBy": channelLastUpdatedBy,
    "effectiveStartDate": "${effectiveStartDate!.year.toString().padLeft(4, '0')}-${effectiveStartDate!.month.toString().padLeft(2, '0')}-${effectiveStartDate!.day.toString().padLeft(2, '0')}",
    "effectiveEndDate": "${effectiveEndDate!.year.toString().padLeft(4, '0')}-${effectiveEndDate!.month.toString().padLeft(2, '0')}-${effectiveEndDate!.day.toString().padLeft(2, '0')}",
  };
}
