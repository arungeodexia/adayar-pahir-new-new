/// taskId : 1
/// taskTitle : "Screening Check"
/// description : "All Patients are required to complete the screening checks till the surgery day. It is very important that you provide accurate information"
/// expiry : "2021-04-28"
/// completionPercentage : "65%"
/// nextQuestionId : 2

class TaskDetails {
  TaskDetails({
    int? taskId,
    String? taskTitle,
    String? description,
    String? alternateDescription,
    String? expiry,
    String? completionPercentage,
    int? nextQuestionId,
  }) {
    _taskId = taskId;
    _taskTitle = taskTitle;
    _description = description;
    _expiry = expiry;
    _completionPercentage = completionPercentage;
    _nextQuestionId = nextQuestionId;
  }

  TaskDetails.fromJson(dynamic json) {
    _taskId = json['taskId'];
    _taskTitle = json['taskTitle'];
    _description = json['description'];
    _alternateDescription = json['alternateDescription'];
    _expiry = json['expiry'];
    _completionPercentage = json['completionPercentage'];
    _nextQuestionId = json['nextQuestionId'];
  }
  int? _taskId;
  String? _taskTitle;
  String? _description;
  String? _alternateDescription;
  String? _expiry;
  String? _completionPercentage;
  int? _nextQuestionId;

  int? get taskId => _taskId;
  String? get taskTitle => _taskTitle;
  String? get description => _description;
  String? get alternateDescription => _alternateDescription;
  String? get expiry => _expiry;
  String? get completionPercentage => _completionPercentage;
  int? get nextQuestionId => _nextQuestionId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskId'] = _taskId;
    map['taskTitle'] = _taskTitle;
    map['description'] = _description;
    map['alternateDescription'] = _alternateDescription;
    map['expiry'] = _expiry;
    map['completionPercentage'] = _completionPercentage;
    map['nextQuestionId'] = _nextQuestionId;
    return map;
  }
}
