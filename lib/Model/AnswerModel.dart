// To parse this JSON data, do
//
//     final answerModel = answerModelFromJson(jsonString);

import 'dart:convert';

AnswerModel answerModelFromJson(String str) => AnswerModel.fromJson(json.decode(str));

String answerModelToJson(AnswerModel data) => json.encode(data.toJson());

class AnswerModel {
  AnswerModel({
    required this.answers,
  });

  List<Answer> answers;

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    answers: List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };
}

class Answer {
  Answer({
    this.optionId,
    this.optionNotes,
    this.questionId,
  });

  int? optionId;
  String? optionNotes;
  int? questionId;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    optionId: json["optionId"],
    optionNotes: json["optionNotes"],
    questionId: json["questionId"],
  );

  Map<String, dynamic> toJson() => {
    "optionId": optionId,
    "optionNotes": optionNotes,
    "questionId": questionId,
  };
}
