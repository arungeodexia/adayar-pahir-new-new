///Updated Model
/*
class AddResourceModel {
  String id;
  int userId;
  String firstName;
  String middleName;
  String lastName;
  String email;
  String gender;
  String level;
  int sharedByUserId;
  String countryCode;
  String mobile;
  String city;
  String state;
  String country;
  int skillId;
  String skill;
  String profilePicture;
  int favorite;
  String createdDate;
  int rating;
  String review;
  String ratingDate;
  String notes;
  String notesDate;
  List<SharedDetails> sharedDetails;
  String channelDetails;
  bool isMyResource;
  String skillTags;
  String resourceType;

  AddResourceModel(
      {this.id,
        this.userId,
        this.firstName,
        this.middleName,
        this.lastName,
        this.email,
        this.gender,
        this.level,
        this.sharedByUserId,
        this.countryCode,
        this.mobile,
        this.city,
        this.state,
        this.country,
        this.skillId,
        this.skill,
        this.profilePicture,
        this.favorite,
        this.createdDate,
        this.rating,
        this.review,
        this.ratingDate,
        this.notes,
        this.notesDate,
        this.sharedDetails,
        this.channelDetails,
        this.isMyResource,
        this.skillTags,
        this.resourceType});

  AddResourceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    email = json['email'];
    gender = json['gender'];
    level = json['level'];
    sharedByUserId = json['sharedByUserId'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    skillId = json['skill_id'];
    skill = json['skill'];
    profilePicture = json['profilePicture'];
    favorite = json['favorite'];
    createdDate = json['createdDate'];
    rating = json['rating'];
    review = json['review'];
    ratingDate = json['rating_date'];
    notes = json['notes'];
    notesDate = json['notes_date'];
    if (json['sharedDetails'] != null) {
      sharedDetails = new List<SharedDetails>();
      json['sharedDetails'].forEach((v) {
        sharedDetails.add(new SharedDetails.fromJson(v));
      });
    }
    channelDetails = json['channelDetails'];
    isMyResource = json['isMyResource'];
    skillTags = json['skillTags'];
    resourceType = json['resourceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['level'] = this.level;
    data['sharedByUserId'] = this.sharedByUserId;
    data['countryCode'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['skill_id'] = this.skillId;
    data['skill'] = this.skill;
    data['profilePicture'] = this.profilePicture;
    data['favorite'] = this.favorite;
    data['createdDate'] = this.createdDate;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['rating_date'] = this.ratingDate;
    data['notes'] = this.notes;
    data['notes_date'] = this.notesDate;
    if (this.sharedDetails != null) {
      data['sharedDetails'] =
          this.sharedDetails.map((v) => v.toJson()).toList();
    }
    data['channelDetails'] = this.channelDetails;
    data['isMyResource'] = this.isMyResource;
    data['skillTags'] = this.skillTags;
    data['resourceType'] = this.resourceType;
    return data;
  }
}

class SharedDetails {
  int userId;
  String level;
  int rating;
  String countryCode;
  String mobileNumber;
  String firstName;
  String lastName;
  String pictureUrl;

  SharedDetails(
      {this.userId,
        this.level,
        this.rating,
        this.countryCode,
        this.mobileNumber,
        this.firstName,
        this.lastName,
        this.pictureUrl});

  SharedDetails.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    level = json['level'];
    rating = json['rating'];
    countryCode = json['countryCode'];
    mobileNumber = json['mobileNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    pictureUrl = json['pictureUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['level'] = this.level;
    data['rating'] = this.rating;
    data['countryCode'] = this.countryCode;
    data['mobileNumber'] = this.mobileNumber;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['pictureUrl'] = this.pictureUrl;
    return data;
  }
}
*/


class AddResourceModel {
  String? _id;
  int? _userId;
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _email;
  String? _gender;

  String? _level;
  bool? _isMyResource;

  int? _sharedByUserId;
  String? _countryCode;
  String? _mobile;
  String? _city;
  String? _state;
  String? _country;
  int? _skillId;
  String? _skill;
  String? _profilePicture;
  String? _profilePictureBase64;
  int? _favorite;
  String? _createdDate;
  int? _rating;
  String? _ratingDate;
  String? _notes;
  String? _skillTags;  // Instead of Notes
  String? _notesDate;
  
  String? _userFingerprintHash;
  String? _accessToken;
  List<SharedDetails>? _sharedDetails;

  String? _resourceType; //internal(App User) or external(neighbourhood)

  AddResourceModel(
      {String? id,
        int? userId,
        String? firstName,
        String? middleName,
        String? lastName,
        String? email,
        String? gender,
        String? level,
        int? sharedByUserId,
        String? countryCode,
        String? mobile,
        String? city,
        String? state,
        String? country,
        int? skillId,
        String? skill,
        String? profilePicture,
        String? profilePictureBase64,
        int? favorite,
        String? createdDate,
        int? rating,
        String? ratingDate,
        String? notes,
        String? skillTags,
        String? notesDate,
        String? userFingerprintHash,
        String? accessToken,
        List<SharedDetails>? sharedDetails}) {
    this._id = id;
    this._userId = userId;
    this._firstName = firstName;
    this._middleName = middleName;
    this._lastName = lastName;
    this._email = email;
    this._gender = gender;
    this._level = level;
    this._sharedByUserId = sharedByUserId;
    this._countryCode = countryCode;
    this._mobile = mobile;
    this._city = city;
    this._state = state;
    this._country = country;
    this._skillId = skillId;
    this._skill = skill;
    this._profilePicture = profilePicture;
    this._profilePictureBase64 = profilePictureBase64;
    this._favorite = favorite;
    this._createdDate = createdDate;
    this._rating = rating;
    this._ratingDate = ratingDate;
    this._notes = notes;
     this._skillTags = skillTags;
    this._notesDate = notesDate;
    this._userFingerprintHash = userFingerprintHash;
    this._accessToken = accessToken;
    this._sharedDetails = sharedDetails;
  }



  AddResourceModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _userId = json['userId'];
    _firstName = json['firstName'];
    _middleName = json['middleName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _gender = json['gender'];

    _level = json['level'];
    _isMyResource = json['isMyResource'];

    _sharedByUserId = json['sharedByUserId'];
    _countryCode = json['countryCode'];
    _mobile = json['mobile'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _skillId = json['skill_id'];
    _skill = json['skill'];
    _profilePicture = json['profilePicture'];
    _profilePictureBase64 = json['profilePictureBase64'];
    _favorite = json['favorite'];
    _createdDate = json['createdDate'];
    _rating = json['rating'];
    _ratingDate = json['rating_date'];
    _notes = json['notes'];
    _skillTags = json['skillTags'];//Instead of Notes
    _notesDate = json['notes_date'];
    _userFingerprintHash = json['userFingerprintHash'];
    _accessToken = json['accessToken'];
     _resourceType = json['resourceType'];

    if (json['sharedDetails'] != null) {
      _sharedDetails = <SharedDetails>[];
      json['sharedDetails'].forEach((v) {
        _sharedDetails!.add(new SharedDetails.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['userId'] = this._userId;
    data['firstName'] = this._firstName;
    data['middleName'] = this._middleName;
    data['lastName'] = this._lastName;
    data['email'] = this._email;
    data['gender'] = this._gender;
    data['level'] = this._level;
    data['isMyResource'] = this._isMyResource;
    data['sharedByUserId'] = this._sharedByUserId;
    data['countryCode'] = this._countryCode;
    data['mobile'] = this._mobile;
    data['city'] = this._city;
    data['state'] = this._state;
    data['country'] = this._country;
    data['skill_id'] = this._skillId;
    data['skill'] = this._skill;
    data['profilePicture'] = this._profilePicture;
    data['profilePictureBase64'] = this._profilePictureBase64;
    data['favorite'] = this._favorite;
    data['createdDate'] = this._createdDate;
    data['rating'] = this._rating;
    data['rating_date'] = this._ratingDate;
    data['notes'] = this._notes;
    data['skillTags'] = this._skillTags;
    data['notes_date'] = this._notesDate;
    data['userFingerprintHash'] = this._userFingerprintHash;
    data['accessToken'] = this._accessToken;
    
    data['resourceType'] = this._resourceType; //Resource type
    
    if (this._sharedDetails != null) {
      data['sharedDetails'] =
          this._sharedDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SharedDetails {
  int? _userId;
  String? _level;
  int? _rating;
  String? _countryCode;
  String? _mobileNumber;
  String? _firstName;
  String? _lastName;
  String? _pictureUrl;
  String? _pictureUrlBase64;

  SharedDetails(
      {int? userId,
        String? level,
        int? rating,
        String? countryCode,
        String? mobileNumber,
        String? firstName,
        String? lastName,
        String? pictureUrl,
      String? pictureUrlBase64}) {
    this._userId = userId;
    this._level = level;
    this._rating = rating;
    this._countryCode = countryCode;
    this._mobileNumber = mobileNumber;
    this._firstName = firstName;
    this._lastName = lastName;
    this._pictureUrl = pictureUrl;
    this._pictureUrlBase64 = pictureUrlBase64;
  }



  SharedDetails.fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _level = json['level'];
    _rating = json['rating'];
    _countryCode = json['countryCode'];
    _mobileNumber = json['mobileNumber'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _pictureUrl = json['pictureUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['level'] = this._level;
    data['rating'] = this._rating;
    data['countryCode'] = this._countryCode;
    data['mobileNumber'] = this._mobileNumber;
    data['firstName'] = this._firstName;
    data['lastName'] = this._lastName;
    data['pictureUrl'] = this._pictureUrl;
    return data;
  }
}



