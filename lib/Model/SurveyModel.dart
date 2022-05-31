/// questions : [{"templateId":1,"questionId":1,"question":"Did you follow the exercise prescribed?"},{"templateId":2,"questionId":2,"question":"Instructions to apply the medication"}]

class SurveyModel {
  List<Questions>? _questions;

  List<Questions>? get questions => _questions;

  SurveyModel({
      List<Questions>? questions}){
    _questions = questions;
}

  SurveyModel.fromJson(dynamic json) {
    if (json['questions'] != null) {
      _questions = [];
      json['questions'].forEach((v) {
        _questions?.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_questions != null) {
      map['questions'] = _questions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// templateId : 1
/// questionId : 1
/// question : "Did you follow the exercise prescribed?"

class Questions {
  int? _templateId;
  int? _questionId;
  String? _question;

  int? get templateId => _templateId;
  int? get questionId => _questionId;
  String? get question => _question;

  Questions({
      int? templateId, 
      int? questionId, 
      String? question}){
    _templateId = templateId;
    _questionId = questionId;
    _question = question;
}

  Questions.fromJson(dynamic json) {
    _templateId = json['templateId'];
    _questionId = json['questionId'];
    _question = json['question'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['templateId'] = _templateId;
    map['questionId'] = _questionId;
    map['question'] = _question;
    return map;
  }

}