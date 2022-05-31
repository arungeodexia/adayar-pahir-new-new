import 'ReviewsListResponse.dart';

class GetReviewResponse {
  String? resourceId;
  int? count;
  List<Reviews>? reviews;

  GetReviewResponse({this.resourceId, this.count, this.reviews});

  GetReviewResponse.fromJson(Map<String, dynamic> json) {
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

//class Reviews {
//  int reviewId;
//  int rating;
//  String review;
//  String reviewDate;
//  int userId;
//  String userName;
//  String userPictureLink;
//  String userCity;
//  String userState;
//
//  Reviews(
//      {this.reviewId,
//        this.rating,
//        this.review,
//        this.reviewDate,
//        this.userId,
//        this.userName,
//        this.userPictureLink,
//        this.userCity,
//        this.userState});
//
//  Reviews.fromJson(Map<String, dynamic> json) {
//    reviewId = json['reviewId'];
//    rating = json['rating'];
//    review = json['review'];
//    reviewDate = json['reviewDate'];
//    userId = json['userId'];
//    userName = json['userName'];
//    userPictureLink = json['userPictureLink'];
//    userCity = json['userCity'];
//    userState = json['userState'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['reviewId'] = this.reviewId;
//    data['rating'] = this.rating;
//    data['review'] = this.review;
//    data['reviewDate'] = this.reviewDate;
//    data['userId'] = this.userId;
//    data['userName'] = this.userName;
//    data['userPictureLink'] = this.userPictureLink;
//    data['userCity'] = this.userCity;
//    data['userState'] = this.userState;
//    return data;
//  }
//}

//class GetReviewResponse {
//  int reviewId;
//  int userId;
//  String resourceId;
//  String userName;
//  int rating;
//  String review;
//
//  GetReviewResponse(
//      {this.reviewId,
//        this.userId,
//        this.resourceId,
//        this.userName,
//        this.rating,
//        this.review});
//
//  GetReviewResponse.fromJson(Map<String, dynamic> json) {
//    reviewId = json['reviewId'];
//    userId = json['userId'];
//    resourceId = json['resourceId'];
//    userName = json['userName'];
//    rating = json['rating'];
//    review = json['review'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['reviewId'] = this.reviewId;
//    data['userId'] = this.userId;
//    data['resourceId'] = this.resourceId;
//    data['userName'] = this.userName;
//    data['rating'] = this.rating;
//    data['review'] = this.review;
//    return data;
//  }
//}


