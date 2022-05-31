/// tasks : [{"taskId":1,"taskTitle":"Screening Check","completionPercentage":"65%"},{"taskId":2,"taskTitle":"Medication Instruction","completionPercentage":"20%"},{"taskId":3,"taskTitle":"Diet Routine Check","completionPercentage":"0%"}]

class Taksmodel {
  Taksmodel({
      List<Tasks>? tasks,}){
    _tasks = tasks;
}

  Taksmodel.fromJson(dynamic json) {
    if (json['tasks'] != null) {
      _tasks = [];
      json['tasks'].forEach((v) {
        _tasks?.add(Tasks.fromJson(v));
      });
    }
  }
  List<Tasks>? _tasks;

  List<Tasks>? get tasks => _tasks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_tasks != null) {
      map['tasks'] = _tasks?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// taskId : 1
/// taskTitle : "Screening Check"
/// completionPercentage : "65%"

class Tasks {
  Tasks({
      int? taskId, 
      String? taskTitle, 
      String? completionPercentage,}){
    _taskId = taskId;
    _taskTitle = taskTitle;
    _completionPercentage = completionPercentage;
}

  Tasks.fromJson(dynamic json) {
    _taskId = json['taskId'];
    _taskTitle = json['taskTitle'];
    _completionPercentage = json['completionPercentage'];
  }
  int? _taskId;
  String? _taskTitle;
  String? _completionPercentage;

  int? get taskId => _taskId;
  String? get taskTitle => _taskTitle;
  String? get completionPercentage => _completionPercentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskId'] = _taskId;
    map['taskTitle'] = _taskTitle;
    map['completionPercentage'] = _completionPercentage;
    return map;
  }

}