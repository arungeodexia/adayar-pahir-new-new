/// orgMembers : [{"orgChannelMemberId":0,"orgMemberId":1,"userId":0,"orgId":1,"orgChannelId":0,"skillId":0,"skillName":null,"skillAlias":null,"countryCode":"+91","mobileNumber":"9545784512","mobileNumberStatus":"ACTIVE","alternativeNumber":null,"professionalInfo":"Dr.","firstName":"Dr. Ramasubramaniyam, M.B.B.S., M.D.","lastName":null,"address1":null,"address2":null,"address3":null,"city":"Chennai","state":"Tamil Nadu","country":"India","userStatus":"ACTIVE","email":"ramasubramaniyam@gmail.com","emailStatus":"ACTIVE","gender":"Male","notes":null,"language":null,"profilePictureLink":"https://aci-assets.s3.amazonaws.com/doctor3.jpg","subscriptionLevel":null,"major1":null,"major2":null,"minor1":null,"minor2":null,"effectiveStartDate":"2022-01-12","effectiveEndDate":"2022-01-12","properties":null},{"orgChannelMemberId":0,"orgMemberId":2,"userId":0,"orgId":1,"orgChannelId":0,"skillId":0,"skillName":null,"skillAlias":null,"countryCode":"+91","mobileNumber":"9631256896","mobileNumberStatus":"ACTIVE","alternativeNumber":null,"professionalInfo":"Dr.","firstName":"Dr. Reena Sathyan, M.B.B.S., M.S.","lastName":null,"address1":null,"address2":null,"address3":null,"city":"Chennai","state":"Tamil Nadu","country":"India","userStatus":"ACTIVE","email":"reena@gmail.com","emailStatus":"ACTIVE","gender":"Female","notes":null,"language":null,"profilePictureLink":"https://aci-assets.s3.amazonaws.com/doctor1.jpg","subscriptionLevel":null,"major1":null,"major2":null,"minor1":null,"minor2":null,"effectiveStartDate":"2022-01-12","effectiveEndDate":"2022-01-12","properties":null},{"orgChannelMemberId":0,"orgMemberId":3,"userId":0,"orgId":1,"orgChannelId":0,"skillId":0,"skillName":null,"skillAlias":null,"countryCode":"+91","mobileNumber":"9874563215","mobileNumberStatus":"ACTIVE","alternativeNumber":null,"professionalInfo":"Dr.","firstName":"Dr. Krish, M.B.B.S., M.S.","lastName":null,"address1":null,"address2":null,"address3":null,"city":"Chennai","state":"Tamil Nadu","country":"India","userStatus":"ACTIVE","email":"krish@gmail.com","emailStatus":"ACTIVE","gender":"Male","notes":null,"language":null,"profilePictureLink":"https://aci-assets.s3.amazonaws.com/doctor4.jpg","subscriptionLevel":null,"major1":null,"major2":null,"minor1":null,"minor2":null,"effectiveStartDate":"2022-01-12","effectiveEndDate":"2022-01-12","properties":null},{"orgChannelMemberId":0,"orgMemberId":4,"userId":0,"orgId":1,"orgChannelId":0,"skillId":0,"skillName":null,"skillAlias":null,"countryCode":"+91","mobileNumber":"9375442235","mobileNumberStatus":"ACTIVE","alternativeNumber":null,"professionalInfo":"Dr.","firstName":"Dr. Bharathi, M.B.B.S., M.D.","lastName":null,"address1":null,"address2":null,"address3":null,"city":"Chennai","state":"Tamil Nadu","country":"India","userStatus":"ACTIVE","email":"bharathi@gmail.com","emailStatus":"ACTIVE","gender":"Female","notes":null,"language":null,"profilePictureLink":"https://aci-assets.s3.amazonaws.com/doctor2.jpg","subscriptionLevel":null,"major1":null,"major2":null,"minor1":null,"minor2":null,"effectiveStartDate":"2022-01-12","effectiveEndDate":"2022-01-12","properties":null}]

class CareTeamModel {
  CareTeamModel({
      List<OrgMembers>? orgMembers,}){
    _orgMembers = orgMembers;
}

  CareTeamModel.fromJson(dynamic json) {
    if (json['orgMembers'] != null) {
      _orgMembers = [];
      json['orgMembers'].forEach((v) {
        _orgMembers?.add(OrgMembers.fromJson(v));
      });
    }
  }
  List<OrgMembers>? _orgMembers;

  List<OrgMembers>? get orgMembers => _orgMembers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_orgMembers != null) {
      map['orgMembers'] = _orgMembers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// orgChannelMemberId : 0
/// orgMemberId : 1
/// userId : 0
/// orgId : 1
/// orgChannelId : 0
/// skillId : 0
/// skillName : null
/// skillAlias : null
/// countryCode : "+91"
/// mobileNumber : "9545784512"
/// mobileNumberStatus : "ACTIVE"
/// alternativeNumber : null
/// professionalInfo : "Dr."
/// firstName : "Dr. Ramasubramaniyam, M.B.B.S., M.D."
/// lastName : null
/// address1 : null
/// address2 : null
/// address3 : null
/// city : "Chennai"
/// state : "Tamil Nadu"
/// country : "India"
/// userStatus : "ACTIVE"
/// email : "ramasubramaniyam@gmail.com"
/// emailStatus : "ACTIVE"
/// gender : "Male"
/// notes : null
/// language : null
/// profilePictureLink : "https://aci-assets.s3.amazonaws.com/doctor3.jpg"
/// subscriptionLevel : null
/// major1 : null
/// major2 : null
/// minor1 : null
/// minor2 : null
/// effectiveStartDate : "2022-01-12"
/// effectiveEndDate : "2022-01-12"
/// properties : null

class OrgMembers {
  OrgMembers({
      int? orgChannelMemberId, 
      int? orgMemberId, 
      int? userId, 
      int? orgId, 
      int? orgChannelId, 
      int? skillId, 
      dynamic skillName, 
      dynamic skillAlias, 
      String? countryCode, 
      String? mobileNumber, 
      String? mobileNumberStatus, 
      dynamic alternativeNumber, 
      String? professionalInfo, 
      String? firstName, 
      dynamic lastName, 
      dynamic address1, 
      dynamic address2, 
      dynamic address3, 
      String? city, 
      String? state, 
      String? country, 
      String? userStatus, 
      String? email, 
      String? emailStatus, 
      String? gender, 
      dynamic notes, 
      dynamic language, 
      String? profilePictureLink, 
      dynamic subscriptionLevel, 
      dynamic major1, 
      dynamic major2, 
      dynamic minor1, 
      dynamic minor2, 
      String? effectiveStartDate, 
      String? effectiveEndDate, 
      dynamic properties,}){
    _orgChannelMemberId = orgChannelMemberId;
    _orgMemberId = orgMemberId;
    _userId = userId;
    _orgId = orgId;
    _orgChannelId = orgChannelId;
    _skillId = skillId;
    _skillName = skillName;
    _skillAlias = skillAlias;
    _countryCode = countryCode;
    _mobileNumber = mobileNumber;
    _mobileNumberStatus = mobileNumberStatus;
    _alternativeNumber = alternativeNumber;
    _professionalInfo = professionalInfo;
    _firstName = firstName;
    _lastName = lastName;
    _address1 = address1;
    _address2 = address2;
    _address3 = address3;
    _city = city;
    _state = state;
    _country = country;
    _userStatus = userStatus;
    _email = email;
    _emailStatus = emailStatus;
    _gender = gender;
    _notes = notes;
    _language = language;
    _profilePictureLink = profilePictureLink;
    _subscriptionLevel = subscriptionLevel;
    _major1 = major1;
    _major2 = major2;
    _minor1 = minor1;
    _minor2 = minor2;
    _effectiveStartDate = effectiveStartDate;
    _effectiveEndDate = effectiveEndDate;
    _properties = properties;
}

  OrgMembers.fromJson(dynamic json) {
    _orgChannelMemberId = json['orgChannelMemberId'];
    _orgMemberId = json['orgMemberId'];
    _userId = json['userId'];
    _orgId = json['orgId'];
    _orgChannelId = json['orgChannelId'];
    _skillId = json['skillId'];
    _skillName = json['skillName'];
    _skillAlias = json['skillAlias'];
    _countryCode = json['countryCode'];
    _mobileNumber = json['mobileNumber'];
    _mobileNumberStatus = json['mobileNumberStatus'];
    _alternativeNumber = json['alternativeNumber'];
    _professionalInfo = json['professionalInfo'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _address1 = json['address1'];
    _address2 = json['address2'];
    _address3 = json['address3'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _userStatus = json['userStatus'];
    _email = json['email'];
    _emailStatus = json['emailStatus'];
    _gender = json['gender'];
    _notes = json['notes'];
    _language = json['language'];
    _profilePictureLink = json['profilePictureLink'];
    _subscriptionLevel = json['subscriptionLevel'];
    _major1 = json['major1'];
    _major2 = json['major2'];
    _minor1 = json['minor1'];
    _minor2 = json['minor2'];
    _effectiveStartDate = json['effectiveStartDate'];
    _effectiveEndDate = json['effectiveEndDate'];
    _properties = json['properties'];
  }
  int? _orgChannelMemberId;
  int? _orgMemberId;
  int? _userId;
  int? _orgId;
  int? _orgChannelId;
  int? _skillId;
  dynamic _skillName;
  dynamic _skillAlias;
  String? _countryCode;
  String? _mobileNumber;
  String? _mobileNumberStatus;
  dynamic _alternativeNumber;
  String? _professionalInfo;
  String? _firstName;
  dynamic _lastName;
  dynamic _address1;
  dynamic _address2;
  dynamic _address3;
  String? _city;
  String? _state;
  String? _country;
  String? _userStatus;
  String? _email;
  String? _emailStatus;
  String? _gender;
  dynamic _notes;
  dynamic _language;
  String? _profilePictureLink;
  dynamic _subscriptionLevel;
  dynamic _major1;
  dynamic _major2;
  dynamic _minor1;
  dynamic _minor2;
  String? _effectiveStartDate;
  String? _effectiveEndDate;
  dynamic _properties;

  int? get orgChannelMemberId => _orgChannelMemberId;
  int? get orgMemberId => _orgMemberId;
  int? get userId => _userId;
  int? get orgId => _orgId;
  int? get orgChannelId => _orgChannelId;
  int? get skillId => _skillId;
  dynamic get skillName => _skillName;
  dynamic get skillAlias => _skillAlias;
  String? get countryCode => _countryCode;
  String? get mobileNumber => _mobileNumber;
  String? get mobileNumberStatus => _mobileNumberStatus;
  dynamic get alternativeNumber => _alternativeNumber;
  String? get professionalInfo => _professionalInfo;
  String? get firstName => _firstName;
  dynamic get lastName => _lastName;
  dynamic get address1 => _address1;
  dynamic get address2 => _address2;
  dynamic get address3 => _address3;
  String? get city => _city;
  String? get state => _state;
  String? get country => _country;
  String? get userStatus => _userStatus;
  String? get email => _email;
  String? get emailStatus => _emailStatus;
  String? get gender => _gender;
  dynamic get notes => _notes;
  dynamic get language => _language;
  String? get profilePictureLink => _profilePictureLink;
  dynamic get subscriptionLevel => _subscriptionLevel;
  dynamic get major1 => _major1;
  dynamic get major2 => _major2;
  dynamic get minor1 => _minor1;
  dynamic get minor2 => _minor2;
  String? get effectiveStartDate => _effectiveStartDate;
  String? get effectiveEndDate => _effectiveEndDate;
  dynamic get properties => _properties;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orgChannelMemberId'] = _orgChannelMemberId;
    map['orgMemberId'] = _orgMemberId;
    map['userId'] = _userId;
    map['orgId'] = _orgId;
    map['orgChannelId'] = _orgChannelId;
    map['skillId'] = _skillId;
    map['skillName'] = _skillName;
    map['skillAlias'] = _skillAlias;
    map['countryCode'] = _countryCode;
    map['mobileNumber'] = _mobileNumber;
    map['mobileNumberStatus'] = _mobileNumberStatus;
    map['alternativeNumber'] = _alternativeNumber;
    map['professionalInfo'] = _professionalInfo;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['address1'] = _address1;
    map['address2'] = _address2;
    map['address3'] = _address3;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['userStatus'] = _userStatus;
    map['email'] = _email;
    map['emailStatus'] = _emailStatus;
    map['gender'] = _gender;
    map['notes'] = _notes;
    map['language'] = _language;
    map['profilePictureLink'] = _profilePictureLink;
    map['subscriptionLevel'] = _subscriptionLevel;
    map['major1'] = _major1;
    map['major2'] = _major2;
    map['minor1'] = _minor1;
    map['minor2'] = _minor2;
    map['effectiveStartDate'] = _effectiveStartDate;
    map['effectiveEndDate'] = _effectiveEndDate;
    map['properties'] = _properties;
    return map;
  }

}