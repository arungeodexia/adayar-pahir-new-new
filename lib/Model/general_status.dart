class GeneralStatus {
  int? _statuscode;
  String? _statusdata;

  GeneralStatus({int? statuscode, String? statusdata}) {
    this._statuscode = statuscode;
    this._statusdata = statusdata;
  }

  int? get statuscode => _statuscode;
  set statuscode(int? statuscode) => _statuscode = statuscode;
  String? get statusdata => _statusdata;
  set statusdata(String? statusdata) => _statusdata = statusdata;

  GeneralStatus.fromJson(Map<String, dynamic> json) {
    _statuscode = json['statuscode'];
    _statusdata = json['statusdata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statuscode'] = this._statuscode;
    data['statusdata'] = this._statusdata;
    return data;
  }
}
