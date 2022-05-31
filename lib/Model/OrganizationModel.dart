// To parse this JSON data, do
//
//     final organizationModel = organizationModelFromJson(jsonString);

import 'dart:convert';

OrganizationModel organizationModelFromJson(String str) => OrganizationModel.fromJson(json.decode(str));

String organizationModelToJson(OrganizationModel data) => json.encode(data.toJson());

class OrganizationModel {
  OrganizationModel({
    this.organizations,
    this.organizationCount,
  });

  List<Organization>? organizations;
  int? organizationCount;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) => OrganizationModel(
    organizations: List<Organization>.from(json["organizations"].map((x) => Organization.fromJson(x))),
    organizationCount: json["organizationCount"],
  );

  Map<String, dynamic> toJson() => {
    "organizations": List<dynamic>.from(organizations!.map((x) => x.toJson())),
    "organizationCount": organizationCount,
  };
}

class Organization {
  Organization({
    this.orgId,
    this.parentOrgId,
    this.orgName,
    this.orgDescription,
    this.orgPictureLink,
    this.status,
    this.primaryContactName,
    this.primaryContactDesignation,
    this.primaryContactEmail,
    this.primaryContactMobile,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.orgAddress,
  });

  int? orgId;
  int? parentOrgId;
  String? orgName;
  String? orgDescription;
  String? orgPictureLink;
  String? status;
  String? primaryContactName;
  String? primaryContactDesignation;
  String? primaryContactEmail;
  String? primaryContactMobile;
  DateTime? effectiveStartDate;
  DateTime? effectiveEndDate;
  dynamic orgAddress;

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    orgId: json["orgId"],
    parentOrgId: json["parentOrgId"],
    orgName: json["orgName"],
    orgDescription: json["orgDescription"],
    orgPictureLink: json["orgPictureLink"],
    status: json["status"],
    primaryContactName: json["primaryContactName"],
    primaryContactDesignation: json["primaryContactDesignation"],
    primaryContactEmail: json["primaryContactEmail"],
    primaryContactMobile: json["primaryContactMobile"],
    effectiveStartDate: DateTime.parse(json["effectiveStartDate"]),
    effectiveEndDate: DateTime.parse(json["effectiveEndDate"]),
    orgAddress: json["orgAddress"],
  );

  Map<String, dynamic> toJson() => {
    "orgId": orgId,
    "parentOrgId": parentOrgId,
    "orgName": orgName,
    "orgDescription": orgDescription,
    "orgPictureLink": orgPictureLink,
    "status": status,
    "primaryContactName": primaryContactName,
    "primaryContactDesignation": primaryContactDesignation,
    "primaryContactEmail": primaryContactEmail,
    "primaryContactMobile": primaryContactMobile,
    "effectiveStartDate": effectiveStartDate!.toIso8601String(),
    "effectiveEndDate": effectiveEndDate!.toIso8601String(),
    "orgAddress": orgAddress,
  };
}
