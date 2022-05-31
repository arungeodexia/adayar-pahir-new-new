/*{
  "accessToken": "string",
  "appId": "string",
  "appName": "string",
  "appVersion": "string",
  "buildNumber": "string",
  "deviceToken": "string",
  "imeiNumber": "string",
  "osName": "string",
  "osVersion": "string",
  "userFingerprintHash": "string"
}*/
class DeviceInfoModel {
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

  DeviceInfoModel(
      {required String accessToken,
        required String appId,
        required String appName,
        required String appVersion,
        required String buildNumber,
        required String deviceToken,
        required String imeiNumber,
        required String osName,
        required String osVersion,
        required String userFingerprintHash,
        }) {
    this._accessToken = accessToken;
    this._appId = appId;
    this._appName = appName;
    this._appVersion = appVersion;
    this._buildNumber = buildNumber;
    this._deviceToken = deviceToken;
    this._imeiNumber = imeiNumber;
    this._osName = osName;
    this._osVersion = osVersion;
    this._userFingerprintHash = userFingerprintHash;
  }



  DeviceInfoModel.fromJson(json) {
    _accessToken = json['accessToken'];
    _appId = json['appId'];
    _appName = json['appName'];
    _appVersion = json['appVersion'];
    _buildNumber = json['buildNumber'];
    _deviceToken = json['deviceToken'];
    _imeiNumber = json['imeiNumber'];
    _osName = json['osName'];
    _osVersion = json['osVersion'];
   _userFingerprintHash = json['userFingerprintHash'];
   
  }

  String get appName => appName;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this._accessToken;
    data['appId'] = this._appId;
    data['appName'] = this._appName;
    data['appVersion'] = this._appVersion;
    data['buildNumber'] = this._buildNumber;
    data['deviceToken'] = this._deviceToken;
    data['imeiNumber'] = this._imeiNumber;
    data['osName'] = this._osName;
    data['osVersion'] = this._osVersion;
    data['userFingerprintHash'] = this._userFingerprintHash;
  
    return data;
  }


  set accessToken(String value) {
    _accessToken = value;
  }


  set userFingerprintHash(String value) {
    _userFingerprintHash = value;
  }


  set osVersion(String value) {
    _osVersion = value;
  }


  set osName(String value) {
    _osName = value;
  }


  set imeiNumber(String value) {
    _imeiNumber = value;
  }


  set deviceToken(String value) {
    _deviceToken = value;
  }


  set buildNumber(String value) {
    _buildNumber = value;
  }


  set appVersion(String value) {
    _appVersion = value;
  }


  set appName(String value) {
    _appName = value;
  }


  set appId(String value) {
    _appId = value;
  }
}

