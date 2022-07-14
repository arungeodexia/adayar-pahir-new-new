import 'dart:convert';

import 'package:flutter/material.dart';

/// userId : 57
/// userName : "Sam"
/// topText : "Your tumor surgery is scheduled for January 8th 2:00 PM"
/// question : {"templateid":2,"questionId":2,"question":"Instructions to apply the medication","questionType":"video","url":"https://aci-assets.s3.amazonaws.com/howtoapply.mp4","answerType":"choices","choices":[{"questionId":3,"question":"a. Instruction is clear","questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":4,"order":2,"question":"b. Video quality is good","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":5,"question":"c. Audio clear","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":1,"option":"Yes","url":null},{"optionId":2,"option":"No","url":null}],"hasNext":false,"hasPrevious":true}],"consolidateOptions":true,"hasNext":false,"hasPrevious":true}

class SurveyDetailsModel {
  int? _userId;
  String? _userName;
  String? _topText;
  Question? _question;

  int? get userId => _userId;
  String? get userName => _userName;
  String? get topText => _topText;
  Question? get question => _question;

  SurveyDetailsModel({
      int? userId,
      String? userName,
      String? topText,
      Question? question}){
    _userId = userId;
    _userName = userName;
    _topText = topText;
    _question = question;
}

  SurveyDetailsModel.fromJson(dynamic json) {
    _userId = json['userId'];
    _userName = json['userName'];
    _topText = json['topText'];
    _question = json['question'] != null ? Question.fromJson(json['question']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userId'] = _userId;
    map['userName'] = _userName;
    map['topText'] = _topText;
    if (_question != null) {
      map['question'] = _question?.toJson();
    }
    return map;
  }

}

/// templateid : 2
/// questionId : 2
/// question : "Instructions to apply the medication"
/// questionType : "video"
/// url : "https://aci-assets.s3.amazonaws.com/howtoapply.mp4"
/// answerType : "choices"
/// choices : [{"questionId":3,"question":"a. Instruction is clear","questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":4,"order":2,"question":"b. Video quality is good","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}],"hasNext":false,"hasPrevious":true},{"questionId":5,"question":"c. Audio clear","description":null,"questionType":"text","url":null,"answerType":"radio","options":[{"optionId":1,"option":"Yes","url":null},{"optionId":2,"option":"No","url":null}],"hasNext":false,"hasPrevious":true}]
/// consolidateOptions : true
/// hasNext : false
/// hasPrevious : true

class Question {
  int? _templateid;
  int? _questionId;
  int? _nextQuestionId;
  String? _question;
  String? _questionDescription;
  String? _questionType;
  String? _url;
  String? _answerType;
  String? _completionProgress;
  String? _expiryDate;
  String? _expiryText;
  List<Options>? _options;
  List<Choices>? _choices;
  List<OptionGroup>? _optionGroup;
  bool? _consolidateOptions;
  bool? _hasNext;
  bool? _hasPrevious;
  bool? _hasSkip;

  int? get templateid => _templateid;
  int? get questionId => _questionId;
  int? get nextQuestionId => _nextQuestionId;
  String? get question => _question;
  String? get questionDescription => _questionDescription;
  String? get questionType => _questionType;
  String? get url => _url;
  String? get answerType => _answerType;
  String? get completionProgress => _completionProgress;
  String? get expiryDate => _expiryDate;
  String? get expiryText => _expiryText;
  List<Choices>? get choices => _choices;
  List<Options>? get options => _options;
  List<OptionGroup>? get optionGroup => _optionGroup;
  bool? get consolidateOptions => _consolidateOptions;
  bool? get hasNext => _hasNext;
  bool? get hasPrevious => _hasPrevious;
  bool? get hasSkip => _hasSkip;

  Question({
      int? templateid,
      int? questionId,
      int? nextQuestionId,
      String? question,
      String? questionDescription,
      String? questionType,
      String? url,
      String? answerType,
      String? completionProgress,
      String? expiryDate,
      String? expiryText,
      List<Choices>? choices,
      bool? consolidateOptions,
      bool? hasNext,
      bool? hasPrevious,
      bool? hasSkip}){
    _templateid = templateid;
    _questionId = questionId;
    _question = question;
    _questionDescription = questionDescription;
    _questionType = questionType;
    _url = url;
    _answerType = answerType;
    _completionProgress = completionProgress;
    _expiryDate = expiryDate;
    _expiryText = expiryText;
    _choices = choices;
    _options = options;
    _optionGroup = optionGroup;
    _consolidateOptions = consolidateOptions;
    _hasNext = hasNext;
    _hasPrevious = hasPrevious;
    _hasSkip = hasSkip;
}

  Question.fromJson(dynamic json) {
    _templateid = json['templateid'];
    _questionId = json['questionId'];
    _nextQuestionId = json['nextQuestionId'];
    _question = json['question'];
    _questionDescription = json['questionDescription'];
    _questionType = json['questionType'];
    _url = json['url'];
    _answerType = json['answerType'];
    _completionProgress = json['completionProgress'];
    _expiryDate = json['expiryDate'];
    _expiryText = json['expiryText'];
    if (json['choices'] != null) {
      _choices = [];
      json['choices'].forEach((v) {
        _choices?.add(Choices.fromJson(v));
      });
    }
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
    if (json['optionGroups'] != null) {
      _optionGroup = [];
      json['optionGroups'].forEach((v) {
        _optionGroup?.add(OptionGroup.fromJson(v));
      });
    }

    _consolidateOptions = json['consolidateOptions'];
    _hasNext = json['hasNext'];
    _hasPrevious = json['hasPrevious'];
    _hasSkip = json['allowSkip'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['templateid'] = _templateid;
    map['questionId'] = _questionId;
    map['nextQuestionId'] = _nextQuestionId;
    map['question'] = _question;
    map['questionDescription'] = _questionDescription;
    map['questionType'] = _questionType;
    map['url'] = _url;
    map['answerType'] = _answerType;
    map['completionProgress'] = _completionProgress;
    map['expiryDate'] = _expiryDate;
    if (_choices != null) {
      map['choices'] = _choices?.map((v) => v.toJson()).toList();
    }
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    if (_options != null) {
      map['optionGroups'] = _optionGroup?.map((v) => v.toJson()).toList();
    }

    map['consolidateOptions'] = _consolidateOptions;
    map['hasNext'] = _hasNext;
    map['hasPrevious'] = _hasPrevious;
    map['hasSkip'] = _hasSkip;
    return map;
  }

}

/// questionId : 3
/// question : "a. Instruction is clear"
/// questionType : "text"
/// url : null
/// answerType : "radio"
/// options : [{"optionId":"1","option":"Yes","url":null},{"optionId":"2","option":"No","url":null}]
/// hasNext : false
/// hasPrevious : true

class Choices {
  int? _questionId;
  String? _question;
  String? _questionType;
  dynamic? _url;
  String? _answerType;
  List<Options>? _options;
  bool? _hasNext;
  bool? _hasPrevious;

  int? get questionId => _questionId;
  String? get question => _question;
  String? get questionType => _questionType;
  dynamic? get url => _url;
  String? get answerType => _answerType;
  List<Options>? get options => _options;
  bool? get hasNext => _hasNext;
  bool? get hasPrevious => _hasPrevious;

  Choices({
      int? questionId,
      String? question,
      String? questionType,
      dynamic? url,
      String? answerType,
      List<Options>? options,
      bool? hasNext,
      bool? hasPrevious}){
    _questionId = questionId;
    _question = question;
    _questionType = questionType;
    _url = url;
    _answerType = answerType;
    _options = options;
    _hasNext = hasNext;
    _hasPrevious = hasPrevious;
}

  Choices.fromJson(dynamic json) {
    _questionId = json['questionId'];
    _question = json['question'];
    _questionType = json['questionType'];
    _url = json['url'];
    _answerType = json['answerType'];
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
    _hasNext = json['hasNext'];
    _hasPrevious = json['hasPrevious'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['questionId'] = _questionId;
    map['question'] = _question;
    map['questionType'] = _questionType;
    map['url'] = _url;
    map['answerType'] = _answerType;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    map['hasNext'] = _hasNext;
    map['hasPrevious'] = _hasPrevious;
    return map;
  }

}

/// optionId : "1"
/// option : "Yes"
/// url : null

// class Options {
//   dynamic? _optionId;
//   String? _option;
//   dynamic? _url;
//   int? _select=-1;
//
//   dynamic? get optionId => _optionId;
//   String? get option => _option;
//   int? get select => _select;
//   dynamic? get url => _url;
//
//   set selct(int val) => _select = val; // optionally perform validation, etc
//
//   Options({
//       String? optionId,
//       String? option,
//       int? select,
//       dynamic? url}){
//     _optionId = optionId;
//     _option = option;
//     _select = select;
//     _url = url;
// }
//
//   Options.fromJson(dynamic json) {
//     _optionId = json['optionId'];
//     _option = json['option'];
//     _url = json['url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['optionId'] = _optionId;
//     map['option'] = _option;
//     map['url'] = _url;
//     return map;
//   }
//
//
//
// }

// To parse this JSON data, do
//
//     final options = optionsFromJson(jsonString);


Options optionsFromJson(String str) => Options.fromJson(json.decode(str));

String optionsToJson(Options data) => json.encode(data.toJson());

class Options {
  Options({
    this.optionId,
    this.option,
    this.optionPrefix,
    this.optionSuffix,
    this.optionGroup,
    this.largeText,
    this.nilValue,
    this.url,
    this.select,
  });

  int? optionId;
  String? option;
  dynamic optionPrefix;
  dynamic optionSuffix;
  dynamic optionGroup;
  bool? largeText;
  bool? nilValue;
  dynamic url;
    int? select=-1;


  factory Options.fromJson(Map<String, dynamic> json) => Options(
    optionId: json["optionId"],
    option: json["option"],
    optionPrefix: json["optionPrefix"],
    optionSuffix: json["optionSuffix"],
    optionGroup: json["optionGroup"],
    largeText: json["largeText"],
    nilValue: json["nilValue"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "optionId": optionId,
    "option": option,
    "optionPrefix": optionPrefix,
    "optionSuffix": optionSuffix,
    "optionGroup": optionGroup,
    "largeText": largeText,
    "nilValue": nilValue,
    "url": url,
  };
}

class OptionGroup {
  OptionGroup({
    this.optionGroup,
    this.optionGroups,
  });

  String? optionGroup;
  List<OptionText>? optionGroups;

  factory OptionGroup.fromJson(Map<String, dynamic> json) => OptionGroup(
    optionGroup: json["optionGroup"],
    optionGroups: List<OptionText>.from(json["optionGroups"].map((x) => OptionText.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "optionGroup": optionGroup,
    "optionGroups": List<dynamic>.from(optionGroups!.map((x) => x.toJson())),
  };
}

class OptionText {
  OptionText({
    this.optionId,
    this.option,
    this.optionPrefix,
    this.optionSuffix,
    this.optionGroup,
    this.url,
    this.textEditingController,
    this.largeText,
    this.nilValue,
  });

  int? optionId;
  dynamic? option;
  String? optionPrefix;
  String? optionSuffix;
  String? optionGroup;
  dynamic? url;
  TextEditingController? textEditingController;
  bool? largeText;
  bool? nilValue;

  factory OptionText.fromJson(Map<String, dynamic> json) => OptionText(
    optionId: json["optionId"],
    option: json["option"],
    optionPrefix: json["optionPrefix"],
    optionSuffix: json["optionSuffix"],
    optionGroup: json["optionGroup"],
    url: json["url"],
    largeText: json["largeText"],
    nilValue: json["nilValue"],
    textEditingController: TextEditingController(),
  );

  Map<String, dynamic> toJson() => {
    "optionId": optionId,
    "option": option,
    "optionPrefix": optionPrefix,
    "optionSuffix": optionSuffix,
    "optionGroup": optionGroup,
    "url": url,
    "largeText": largeText,
    "nilValue": nilValue,
  };
}
