class SkillItemModel {
  int? _skillId;
  String? _skillName;
  String? _skillDescription;
  String? _skillIconUrl;
  String? _effectiveStartDate;
  String? _effectiveEndDate;

  SkillItemModel(
      {int? skillId,
        String? skillName,
        String? skillDescription,
        String? skillIconUrl,
        String? effectiveStartDate,
        String? effectiveEndDate}) {
    this._skillId = skillId;
    this._skillName = skillName;
    this._skillDescription = skillDescription;
    this._skillIconUrl = skillIconUrl;
    this._effectiveStartDate = effectiveStartDate;
    this._effectiveEndDate = effectiveEndDate;
  }

  int get skillId => _skillId!;
  set skillId(int skillId) => _skillId = skillId;
  String get skillName => _skillName!;
  set skillName(String skillName) => _skillName = skillName;
  String get skillDescription => _skillDescription!;
  set skillDescription(String skillDescription) =>
      _skillDescription = skillDescription;
  set skillIconUrl(Null skillIconUrl) => _skillIconUrl = skillIconUrl;
  String get effectiveStartDate => _effectiveStartDate!;
  set effectiveStartDate(String effectiveStartDate) =>
      _effectiveStartDate = effectiveStartDate;
  String get effectiveEndDate => _effectiveEndDate!;
  set effectiveEndDate(String effectiveEndDate) =>
      _effectiveEndDate = effectiveEndDate;

  SkillItemModel.fromJson(Map<String, dynamic> json) {
    _skillId = json['skillId'];
    _skillName = json['skillName'];
    _skillDescription = json['skillDescription'];
    _skillIconUrl = json['skillIconUrl'];
    _effectiveStartDate = json['effectiveStartDate'];
    _effectiveEndDate = json['effectiveEndDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skillId'] = this._skillId;
    data['skillName'] = this._skillName;
    data['skillDescription'] = this._skillDescription;
    data['skillIconUrl'] = this._skillIconUrl;
    data['effectiveStartDate'] = this._effectiveStartDate;
    data['effectiveEndDate'] = this._effectiveEndDate;
    return data;
  }
}
