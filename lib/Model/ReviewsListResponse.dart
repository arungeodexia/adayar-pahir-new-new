class ReviewsListResponse {
  String? resourceId;
  int? count;
  List<Reviews>? reviews;

  ReviewsListResponse({this.resourceId, this.count, this.reviews});

  ReviewsListResponse.fromJson(Map<String, dynamic> json) {
    resourceId = json['resourceId'];
    count = json['count'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceId'] = this.resourceId;
    data['count'] = this.count;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? reviewId;
  int? rating;
  String? review;
  String? reviewDate;
  int? userId;
  String? userName;
  String? userPictureLink;
  String? userCity;
  String? userState;
  String? userCountryCode;
  String? userMobileNumber;
  String? userEmail;

  Reviews(
      {this.reviewId,
        this.rating,
        this.review,
        this.reviewDate,
        this.userId,
        this.userName,
        this.userPictureLink,
        this.userCity,
        this.userState,
        this.userCountryCode,
        this.userMobileNumber,
        this.userEmail});

  Reviews.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    rating = json['rating'];
    review = json['review'];
    reviewDate = json['reviewDate'];
    userId = json['userId'];
    userName = json['userName'];
    userPictureLink = json['userPictureLink'];
    userCity = json['userCity'];
    userState = json['userState'];
    userCountryCode = json['userCountryCode'];
    userMobileNumber = json['userMobileNumber'];
    userEmail = json['userEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewId'] = this.reviewId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['reviewDate'] = this.reviewDate;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userPictureLink'] = this.userPictureLink;
    data['userCity'] = this.userCity;
    data['userState'] = this.userState;
    data['userCountryCode'] = this.userCountryCode;
    data['userMobileNumber'] = this.userMobileNumber;
    data['userEmail'] = this.userEmail;
    return data;
  }
}