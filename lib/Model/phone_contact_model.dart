class PhoneContactModel {
  //int? _contactUserId;
  String? _countryCode;
  String? _mobileNumber;
  String? _firstName;
  //int? _userId;

  PhoneContactModel(
      {int? contactUserId,
        String? countryCode,
        String? mobileNumber,
       String? firstName,
        int? userId}) {
  //  this._contactUserId = contactUserId;
    this._countryCode = countryCode;
    this._mobileNumber = mobileNumber;
   this._firstName = firstName;
  //  this._userId = userId;
  }

  //int get contactUserId => _contactUserId;
  //set contactUserId(int contactUserId) => _contactUserId = contactUserId;
  String get countryCode => _countryCode!;
  set countryCode(String countryCode) => _countryCode = countryCode;
  String get mobileNumber => _mobileNumber!;
  set mobileNumber(String mobileNumber) => _mobileNumber = mobileNumber;
  String get firstName => _firstName!;
  set firstName(String firstName) => _firstName = firstName;
  //int get userId => _userId;
  //set userId(int userId) => _userId = userId;

  PhoneContactModel.fromJson(Map<String, dynamic> json) {
    //_contactUserId = json['contactUserId'];
    _countryCode = json['countryCode'];
    _mobileNumber = json['mobileNumber'];
    _firstName = json['firstName'];
    //_userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['contactUserId'] = this._contactUserId;
    data['countryCode'] = this._countryCode;
    data['mobileNumber'] = this._mobileNumber;
    data['firstName'] = this._firstName;
    //data['userId'] = this._userId;
    return data;
  }
}
