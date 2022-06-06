/// appointmentId : 1
/// appointmentType : "Clinic Visit"
/// appointmentDate : "20-01-2022"
/// appointmentDateFormatted : "20 Jan 2022"
/// appointmentTime : "10.30 am"
/// appointmentDuration : "20 Minutes"
/// name : "Dr. Melinda Rose"
/// institute : "Cancer Institue"
/// designation : "M.B.B.S., M.D"
/// address : "Adayar, Chennai - 20"
/// phone1 : "98435 56597"
/// phone2 : null
/// email : "aci@aci.com"

class AppointmentDetails {
  AppointmentDetails({
      int? appointmentId, 
      String? appointmentType, 
      String? appointmentDate, 
      String? appointmentDateFormatted, 
      String? appointmentTime, 
      String? appointmentDuration, 
      String? name, 
      String? picture,
      String? institute,
      String? designation, 
      String? address, 
      String? defaultText,
      String? defaultContact,
      String? phone1,
      dynamic phone2, 
      String? email,}){
    _appointmentId = appointmentId;
    _appointmentType = appointmentType;
    _appointmentDate = appointmentDate;
    _appointmentDateFormatted = appointmentDateFormatted;
    _appointmentTime = appointmentTime;
    _appointmentDuration = appointmentDuration;
    _name = name;
    _picture = picture;
    _institute = institute;
    _designation = designation;
    _address = address;
    _phone1 = phone1;
    _phone2 = phone2;
    _email = email;
    _defaultText = defaultText;
    _defaultContact = defaultContact;
}

  AppointmentDetails.fromJson(dynamic json) {
    _appointmentId = json['appointmentId'];
    _appointmentType = json['appointmentType'];
    _appointmentDate = json['appointmentDate'];
    _appointmentDateFormatted = json['appointmentDateFormatted'];
    _appointmentTime = json['appointmentTime'];
    _appointmentDuration = json['appointmentDuration'];
    _name = json['name'];
    _picture = json['picture'];
    _institute = json['institute'];
    _designation = json['designation'];
    _address = json['address'];
    _defaultText = json['defaultText'];
    _defaultContact = json['defaultContact'];
    _phone1 = json['phone1'];
    _phone2 = json['phone2'];
    _email = json['email'];
  }
  int? _appointmentId;
  String? _appointmentType;
  String? _appointmentDate;
  String? _appointmentDateFormatted;
  String? _appointmentTime;
  String? _appointmentDuration;
  String? _name;
  String? _picture;
  String? _institute;
  String? _designation;
  String? _address;
  String? _defaultContact;
  String? _defaultText;
  String? _phone1;
  dynamic _phone2;
  String? _email;

  int? get appointmentId => _appointmentId;
  String? get appointmentType => _appointmentType;
  String? get appointmentDate => _appointmentDate;
  String? get appointmentDateFormatted => _appointmentDateFormatted;
  String? get appointmentTime => _appointmentTime;
  String? get appointmentDuration => _appointmentDuration;
  String? get name => _name;
  String? get picture => _picture;
  String? get institute => _institute;
  String? get designation => _designation;
  String? get address => _address;
  String? get defaultContact => _defaultContact;
  String? get defaultText => _defaultText;
  String? get phone1 => _phone1;
  dynamic get phone2 => _phone2;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointmentId'] = _appointmentId;
    map['appointmentType'] = _appointmentType;
    map['appointmentDate'] = _appointmentDate;
    map['appointmentDateFormatted'] = _appointmentDateFormatted;
    map['appointmentTime'] = _appointmentTime;
    map['appointmentDuration'] = _appointmentDuration;
    map['name'] = _name;
    map['picture'] = _picture;
    map['institute'] = _institute;
    map['designation'] = _designation;
    map['address'] = _address;
    map['phone1'] = _phone1;
    map['phone2'] = _phone2;
    map['email'] = _email;
    return map;
  }

}