/// accessToken : "string"
/// appId : "string"
/// appName : "string"
/// appVersion : "string"
/// buildNumber : "string"
/// deviceToken : "string"
/// imeiNumber : "string"
/// osName : "string"
/// osVersion : "string"
/// userFingerprintHash : "string"

class DeviceInfo {
  String? _accessToken;
  String? _appId;
  String? _appName;
  String? _appVersion;
  String? _buildNumber;
  String? _deviceToken;
  String? _imeiNumber;
  String? _osName;
  String? _osVersion;
  String? _userFingerprintHash;

  String? get accessToken => _accessToken;
  String? get appId => _appId;
  String? get appName => _appName;
  String? get appVersion => _appVersion;
  String? get buildNumber => _buildNumber;
  String? get deviceToken => _deviceToken;
  String? get imeiNumber => _imeiNumber;
  String? get osName => _osName;
  String? get osVersion => _osVersion;
  String? get userFingerprintHash => _userFingerprintHash;

  DeviceInfo({
      String? accessToken, 
      String? appId, 
      String? appName, 
      String? appVersion, 
      String? buildNumber, 
      String? deviceToken, 
      String? imeiNumber, 
      String? osName, 
      String? osVersion, 
      String? userFingerprintHash}){
    _accessToken = accessToken;
    _appId = appId;
    _appName = appName;
    _appVersion = appVersion;
    _buildNumber = buildNumber;
    _deviceToken = deviceToken;
    _imeiNumber = imeiNumber;
    _osName = osName;
    _osVersion = osVersion;
    _userFingerprintHash = userFingerprintHash;
}

  DeviceInfo.fromJson(dynamic json) {
    _accessToken = json["accessToken"];
    _appId = json["appId"];
    _appName = json["appName"];
    _appVersion = json["appVersion"];
    _buildNumber = json["buildNumber"];
    _deviceToken = json["deviceToken"];
    _imeiNumber = json["imeiNumber"];
    _osName = json["osName"];
    _osVersion = json["osVersion"];
    _userFingerprintHash = json["userFingerprintHash"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["accessToken"] = _accessToken;
    map["appId"] = _appId;
    map["appName"] = _appName;
    map["appVersion"] = _appVersion;
    map["buildNumber"] = _buildNumber;
    map["deviceToken"] = _deviceToken;
    map["imeiNumber"] = _imeiNumber;
    map["osName"] = _osName;
    map["osVersion"] = _osVersion;
    map["userFingerprintHash"] = _userFingerprintHash;
    return map;
  }

}