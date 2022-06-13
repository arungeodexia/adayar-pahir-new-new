class ResourceSearchNew {
  List<SearchResults>? searchResults;
  int? totalMatchCount;

  ResourceSearchNew({this.searchResults, this.totalMatchCount});

  ResourceSearchNew.fromJson(Map<String, dynamic> json) {
    if (json['searchResults'] != null) {
      searchResults = <SearchResults>[];
      json['searchResults'].forEach((v) {
        searchResults!.add(new SearchResults.fromJson(v));
      });
    }
    totalMatchCount = json['totalMatchCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.searchResults != null) {
      data['searchResults'] =
          this.searchResults!.map((v) => v.toJson()).toList();
    }
    data['totalMatchCount'] = this.totalMatchCount;
    return data;
  }
}

class SearchResults {
  String? title;
  String? icon;
  String? notes;
  int? orgId;
  String? orgName;
  int? channelId;
  String? channelName;
  int? showRating;
  int? resourceMatchCount;
  List<ResourceResults>? resourceResults;

  SearchResults(
      {this.title,
        this.icon,
        this.notes,
        this.orgId,
        this.orgName,
        this.channelId,
        this.channelName,
        this.showRating,
        this.resourceMatchCount,
        this.resourceResults});

  SearchResults.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    notes = json['notes'];
    orgId = json['orgId'];
    orgName = json['orgName'];
    channelId = json['channelId'];
    channelName = json['channelName'];
    showRating = json['showRating'];
    resourceMatchCount = json['resourceMatchCount'];
    if (json['resourceResults'] != null) {
      resourceResults = <ResourceResults>[];
      json['resourceResults'].forEach((v) {
        resourceResults!.add(new ResourceResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['notes'] = this.notes;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['channelId'] = this.channelId;
    data['channelName'] = this.channelName;
    data['showRating'] = this.showRating;
    data['resourceMatchCount'] = this.resourceMatchCount;
    if (this.resourceResults != null) {
      data['resourceResults'] =
          this.resourceResults!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResourceResults {
  String? id;
  int? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? gender;
  String? level;
  int? sharedByUserId;
  String? countryCode;
  String? mobile;
  String? city;
  String? state;
  String? country;
  int? skillId;
  String? skill;
  String? address1;
  String? address2;
  String? profilePicture;
  int? favorite;
  String? createdDate;
  int? rating;
  String? review;
  String? ratingDate;
  String? notes;
  String? notesDate;
  List<SharedDetails>? sharedDetails;
  ChannelDetails? channelDetails;
  ContentDetails? contentDetails;
  List<BusinessDetails>? businessDetails;
  bool? isMyResource;
  String? skillTags;
  String? resourceType;
  bool? allowCall;
  bool? allowSms;
  bool? allowWhatsapp;
  bool? allowEmail;
  bool? allowCalendar;
  bool? allowChat;
  bool? displayPhoneNumber;
  bool? allowClass;
  bool? allowGroup;

  //Manually added end
  String? manualAddedReferrerName;
  //Manually added end


  ResourceResults(
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
        this.address1,
        this.address2,
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
        this.contentDetails,
        this.businessDetails,
        this.isMyResource,
        this.skillTags,
        this.resourceType,
        this.allowCall,
        this.allowSms,
        this.allowWhatsapp,
        this.allowEmail,
        this.allowCalendar,
        this.allowChat,
        this.allowClass,
        this.allowGroup});

  ResourceResults.fromJson(Map<String, dynamic> json) {
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
    address1 = json['address1'];
    address2 = json['address2'];
    profilePicture = json['profilePicture'];
    favorite = json['favorite'];
    createdDate = json['createdDate'];
    rating = json['rating'];
    review = json['review'];
    ratingDate = json['rating_date'];
    notes = json['notes'];
    allowSms= json["allowSMS"];
    allowCall= json["allowCall"];
    allowGroup= json["allowGroup"];
    allowClass= json["allowClass"];
    allowWhatsapp= json["allowWhatsapp"];
    allowEmail= json["allowEmail"];
    allowCalendar= json["allowCalendar"];
    allowChat= json["allowChat"];
    displayPhoneNumber= json["displayPhoneNumber"];
    notesDate = json['notes_date'];
    if (json['sharedDetails'] != null) {
      sharedDetails = <SharedDetails>[];
      json['sharedDetails'].forEach((v) {
        sharedDetails!.add(new SharedDetails.fromJson(v));
      });
    }
    channelDetails = json['channelDetails'] != null
        ? new ChannelDetails.fromJson(json['channelDetails'])
        : null;
    contentDetails = json['contentDetails'] != null
        ? new ContentDetails.fromJson(json['contentDetails'])
        : null;
    if (json['businessDetails'] != null) {
      businessDetails = <BusinessDetails>[];
      json['businessDetails'].forEach((v) {
        businessDetails!.add(new BusinessDetails.fromJson(v));
      });
    }
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
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['profilePicture'] = this.profilePicture;
    data['favorite'] = this.favorite;
    data['createdDate'] = this.createdDate;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['rating_date'] = this.ratingDate;
    data['notes'] = this.notes;
    data['allowCall'] = this.allowCall;
    data['allowSms'] = this.allowSms;
    data['allowGroup'] = this.allowGroup;
    data['allowClass'] = this.allowClass;
    data['allowWhatsapp'] = this.allowWhatsapp;
    data['allowEmail'] = this.allowEmail;
    data['allowCalendar'] = this.allowCalendar;
    data['allowChat'] = this.allowChat;
    data['displayPhoneNumber'] = this.displayPhoneNumber;
    data['notes_date'] = this.notesDate;

    if (this.sharedDetails != null) {
      data['sharedDetails'] =
          this.sharedDetails!.map((v) => v.toJson()).toList();
    }
    if (this.channelDetails != null) {
      data['channelDetails'] = this.channelDetails!.toJson();
    }
    if (this.contentDetails != null) {
      data['contentDetails'] = this.contentDetails!.toJson();
    }
    if (this.businessDetails != null) {
      data['businessDetails'] =
          this.businessDetails!.map((v) => v.toJson()).toList();
    }
    data['isMyResource'] = this.isMyResource;
    data['skillTags'] = this.skillTags;
    data['resourceType'] = this.resourceType;
    return data;
  }
}

class SharedDetails {
  int? userId;
  String? level;
  int? rating;
  String? countryCode;
  String? mobileNumber;
  String? firstName;
  String? lastName;
  String? pictureUrl;

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

class ChannelDetails {
  int? orgId;
  String? orgName;
  String? orgIcon;
  int? channelId;
  String? channelName;
  String? channelIcon;
  int? showRating;

  ChannelDetails(
      {this.orgId,
        this.orgName,
        this.orgIcon,
        this.channelId,
        this.channelName,
        this.channelIcon,
        this.showRating});

  ChannelDetails.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    orgName = json['orgName'];
    orgIcon = json['orgIcon'];
    channelId = json['channelId'];
    channelName = json['channelName'];
    channelIcon = json['channelIcon'];
    showRating = json['showRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['orgIcon'] = this.orgIcon;
    data['channelId'] = this.channelId;
    data['channelName'] = this.channelName;
    data['channelIcon'] = this.channelIcon;
    data['showRating'] = this.showRating;
    return data;
  }
}

class ContentDetails {
  int? contentId;
  String? contentTitle;
  String? contentDescription;
  String? contentVersion;
  String? contentCategory;
  String? contentBusinessSector;
  String? contentFileName;
  String? contentFileType;
  String? contentLanguage;
  String? contentStatus;
  String? contentUri;
  String? contentAuthor;
  String? contentUploadDate;
  String? contentTag;
  String? contentNotes;
  String? contentRank;
  String? contentIcon;

  ContentDetails(
      {this.contentId,
        this.contentTitle,
        this.contentDescription,
        this.contentVersion,
        this.contentCategory,
        this.contentBusinessSector,
        this.contentFileName,
        this.contentFileType,
        this.contentLanguage,
        this.contentStatus,
        this.contentUri,
        this.contentAuthor,
        this.contentUploadDate,
        this.contentTag,
        this.contentNotes,
        this.contentRank,
        this.contentIcon});

  ContentDetails.fromJson(Map<String, dynamic> json) {
    contentId = json['contentId'];
    contentTitle = json['contentTitle'];
    contentDescription = json['contentDescription'];
    contentVersion = json['contentVersion'];
    contentCategory = json['contentCategory'];
    contentBusinessSector = json['contentBusinessSector'];
    contentFileName = json['contentFileName'];
    contentFileType = json['contentFileType'];
    contentLanguage = json['contentLanguage'];
    contentStatus = json['contentStatus'];
    contentUri = json['contentUri'];
    contentAuthor = json['contentAuthor'];
    contentUploadDate = json['contentUploadDate'];
    contentTag = json['contentTag'];
    contentNotes = json['contentNotes'];
    contentRank = json['contentRank'];
    contentIcon = json['contentIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentId'] = this.contentId;
    data['contentTitle'] = this.contentTitle;
    data['contentDescription'] = this.contentDescription;
    data['contentVersion'] = this.contentVersion;
    data['contentCategory'] = this.contentCategory;
    data['contentBusinessSector'] = this.contentBusinessSector;
    data['contentFileName'] = this.contentFileName;
    data['contentFileType'] = this.contentFileType;
    data['contentLanguage'] = this.contentLanguage;
    data['contentStatus'] = this.contentStatus;
    data['contentUri'] = this.contentUri;
    data['contentAuthor'] = this.contentAuthor;
    data['contentUploadDate'] = this.contentUploadDate;
    data['contentTag'] = this.contentTag;
    data['contentNotes'] = this.contentNotes;
    data['contentRank'] = this.contentRank;
    data['contentIcon'] = this.contentIcon;
    return data;
  }
}

class BusinessDetails {
  int? businessId;
  int? userId;
  int? orgMemberId;
  int? businessCategoryId;
  String ?businessCategoryName;
  String? businessName;
  String? businessEmail;
  String? businessStartYear;
  String? businessPhoneNumber;
  String? businessWebsite;
  String? businessContact;
  String? businessLogo;
  String? businessParentCompany;
  String? businessLegalForm;
  String? additionalServices;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? county;
  String? state;
  String? country;
  String? zip;
  String? userName;

  BusinessDetails(
      {this.businessId,
        this.userId,
        this.orgMemberId,
        this.businessCategoryId,
        this.businessCategoryName,
        this.businessName,
        this.businessEmail,
        this.businessStartYear,
        this.businessPhoneNumber,
        this.businessWebsite,
        this.businessContact,
        this.businessLogo,
        this.businessParentCompany,
        this.businessLegalForm,
        this.additionalServices,
        this.address1,
        this.address2,
        this.address3,
        this.city,
        this.county,
        this.state,
        this.country,
        this.zip,
        this.userName});

  BusinessDetails.fromJson(Map<String, dynamic> json) {
    businessId = json['businessId'];
    userId = json['userId'];
    orgMemberId = json['orgMemberId'];
    businessCategoryId = json['businessCategoryId'];
    businessCategoryName = json['businessCategoryName'];
    businessName = json['businessName'];
    businessEmail = json['businessEmail'];
    businessStartYear = json['businessStartYear'];
    businessPhoneNumber = json['businessPhoneNumber'];
    businessWebsite = json['businessWebsite'];
    businessContact = json['businessContact'];
    businessLogo = json['businessLogo'];
    businessParentCompany = json['businessParentCompany'];
    businessLegalForm = json['businessLegalForm'];
    additionalServices = json['additionalServices'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    county = json['county'];
    state = json['state'];
    country = json['country'];
    zip = json['zip'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessId'] = this.businessId;
    data['userId'] = this.userId;
    data['orgMemberId'] = this.orgMemberId;
    data['businessCategoryId'] = this.businessCategoryId;
    data['businessCategoryName'] = this.businessCategoryName;
    data['businessName'] = this.businessName;
    data['businessEmail'] = this.businessEmail;
    data['businessStartYear'] = this.businessStartYear;
    data['businessPhoneNumber'] = this.businessPhoneNumber;
    data['businessWebsite'] = this.businessWebsite;
    data['businessContact'] = this.businessContact;
    data['businessLogo'] = this.businessLogo;
    data['businessParentCompany'] = this.businessParentCompany;
    data['businessLegalForm'] = this.businessLegalForm;
    data['additionalServices'] = this.additionalServices;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['city'] = this.city;
    data['county'] = this.county;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zip'] = this.zip;
    data['userName'] = this.userName;
    return data;
  }
}