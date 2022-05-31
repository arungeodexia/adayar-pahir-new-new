// To parse this JSON data, do
//
//     final surveyDetailsModel = surveyDetailsModelFromJson(jsonString);

import 'dart:convert';

SurveyDetailsModelnew surveyDetailsModelFromJson(String str) => SurveyDetailsModelnew.fromJson(json.decode(str));

String surveyDetailsModelToJson(SurveyDetailsModelnew data) => json.encode(data.toJson());

class SurveyDetailsModelnew {
  SurveyDetailsModelnew({
    this.userId,
    this.userName,
    this.topText,
    this.question,
  });

  int? userId;
  String? userName;
  String? topText;
  Question? question;

  factory SurveyDetailsModelnew.fromJson(Map<String, dynamic> json) => SurveyDetailsModelnew(
    userId: json["userId"],
    userName: json["userName"],
    topText: json["topText"],
    question: Question.fromJson(json["question"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "topText": topText,
    "question": question!.toJson(),
  };
}

class Question {
  Question({
    this.templateid,
    this.questionId,
    this.question,
    this.questionType,
    this.url,
    this.answerType,
    this.choices,
    this.options,
    this.consolidateOptions,
    this.hasNext,
    this.hasPrevious,
  });

  int? templateid;
  int? questionId;
  String? question;
  String? questionType;
  String? url;
  String? answerType;
  List<Choice>? choices;
  List<Option>? options;
  bool? consolidateOptions;
  bool? hasNext;
  bool? hasPrevious;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    templateid: json["templateid"],
    questionId: json["questionId"],
    question: json["question"],
    questionType: json["questionType"],
    url: json["url"],
    answerType: json["answerType"],
    choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
    // options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    consolidateOptions: json["consolidateOptions"],
    hasNext: json["hasNext"],
    hasPrevious: json["hasPrevious"],
  );

  Map<String, dynamic> toJson() => {
    "templateid": templateid,
    "questionId": questionId,
    "question": question,
    "questionType": questionType,
    "url": url,
    "answerType": answerType,
    "choices": List<dynamic>.from(choices!.map((x) => x.toJson())),
    "options": List<dynamic>.from(options!.map((x) => x.toJson())),
    "consolidateOptions": consolidateOptions,
    "hasNext": hasNext,
    "hasPrevious": hasPrevious,
  };
}

class Choice {
  Choice({
    this.questionId,
    this.question,
    this.questionType,
    this.url,
    this.answerType,
    this.options,
    this.hasNext,
    this.hasPrevious,
    this.order,
    this.description,
  });

  int? questionId;
  String? question;
  String? questionType;
  dynamic url;
  String? answerType;
  List<Option>? options;
  bool? hasNext;
  bool? hasPrevious;
  int? order;
  dynamic description;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
    questionId: json["questionId"],
    question: json["question"],
    questionType: json["questionType"],
    url: json["url"],
    answerType: json["answerType"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    hasNext: json["hasNext"],
    hasPrevious: json["hasPrevious"],
    order: json["order"] == null ? null : json["order"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "question": question,
    "questionType": questionType,
    "url": url,
    "answerType": answerType,
    "options": List<dynamic>.from(options!.map((x) => x.toJson())),
    "hasNext": hasNext,
    "hasPrevious": hasPrevious,
    "order": order == null ? null : order,
    "description": description,
  };
}

class Option {
  Option({
    this.optionId,
    this.option,
    this.url,
    this.select,
  });

  dynamic optionId;
  String? option;
  dynamic url;
  int? select;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    optionId: json["optionId"],
    option: json["option"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "optionId": optionId,
    "option": option,
    "url": url,
  };
}
