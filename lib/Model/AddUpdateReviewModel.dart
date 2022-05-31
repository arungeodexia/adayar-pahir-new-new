class AddUpdateReviewModel {
  int? rating;
  String? review;

  AddUpdateReviewModel({this.rating, this.review});

  AddUpdateReviewModel.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['review'] = this.review;
    return data;
  }
}