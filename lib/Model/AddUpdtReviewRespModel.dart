class AddUpdtReviewRespModel {
  int? rating;
  String? ratingDate;
  String? resourceId;
  String? review;
  String? reviewDate;
  int? userId;
  String? userName;

  AddUpdtReviewRespModel(
      {this.rating,
        this.ratingDate,
        this.resourceId,
        this.review,
        this.reviewDate,
        this.userId,
        this.userName});

  AddUpdtReviewRespModel.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    ratingDate = json['ratingDate'];
    resourceId = json['resourceId'];
    review = json['review'];
    reviewDate = json['reviewDate'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['ratingDate'] = this.ratingDate;
    data['resourceId'] = this.resourceId;
    data['review'] = this.review;
    data['reviewDate'] = this.reviewDate;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}