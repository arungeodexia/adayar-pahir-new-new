// To parse this JSON data, do
//
//     final trailInfoModel = trailInfoModelFromJson(jsonString);

import 'dart:convert';

TrailInfoModel trailInfoModelFromJson(String str) => TrailInfoModel.fromJson(json.decode(str));

String trailInfoModelToJson(TrailInfoModel data) => json.encode(data.toJson());

class TrailInfoModel {
  TrailInfoModel({
    this.count,
    this.infoMediaUrLs,
  });

  int? count;
  List<String>? infoMediaUrLs;

  factory TrailInfoModel.fromJson(Map<String, dynamic> json) => TrailInfoModel(
    count: json["count"],
    infoMediaUrLs: List<String>.from(json["infoMediaURLs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "infoMediaURLs": List<dynamic>.from(infoMediaUrLs!.map((x) => x)),
  };
}
