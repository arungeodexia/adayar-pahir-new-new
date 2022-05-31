// To parse this JSON data, do
//
//     final successModel = successModelFromJson(jsonString);

import 'dart:convert';

SuccessModel successModelFromJson(String str) => SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
  SuccessModel({
    this.code,
    this.message,
    this.nextQuestionId,
    this.hasPendingQuestions,
  });

  int? code;
  String? message;
  int? nextQuestionId;
  bool? hasPendingQuestions;

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
    code: json["code"],
    message: json["message"],
    nextQuestionId: json["nextQuestionId"],
    hasPendingQuestions: json["hasPendingQuestions"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "nextQuestionId": nextQuestionId,
    "hasPendingQuestions": hasPendingQuestions,
  };
}
