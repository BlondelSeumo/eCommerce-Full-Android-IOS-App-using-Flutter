class ReviewModel {
  int id, rating;
  String dateCreated, status, reviewer, review, avatar;

  ReviewModel(
      {this.id,
      this.dateCreated,
      this.status,
      this.reviewer,
      this.review,
      this.rating,
      this.avatar});

  Map toJson() => {
        'id': id,
        'date_created': dateCreated,
        'status': status,
        'reviewer': reviewer,
        'review': review,
        'rating': rating,
        'avatar': avatar
      };

  ReviewModel.fromJson(Map json) {
    id = json['id'];
    dateCreated = json['date_created'];
    status = json['status'];
    reviewer = json['reviewer'];
    review = json['review'];
    rating = json['rating'];
    avatar = json['reviewer_avatar_urls']['48'];
  }
}

class ReviewHistoryModel {
  String commentDate,
      productId,
      titleProduct,
      imageProduct,
      content,
      star,
      author;

  ReviewHistoryModel(
      {this.commentDate,
      this.productId,
      this.titleProduct,
      this.imageProduct,
      this.content,
      this.star,
      this.author});

  Map toJson() => {
        'product_id': productId,
        'title_product': titleProduct,
        'image_product': imageProduct,
        'content': content,
        'star': star,
        'comment_date': commentDate,
        'comment_author': author
      };

  ReviewHistoryModel.fromJson(Map json) {
    productId = json['product_id'];
    titleProduct = json['title_product'];
    imageProduct = json['image_product'];
    content = json['content'];
    star = json['star'] != '' ? json['star'] : '0';
    commentDate = json['comment_date'];
    author = json['comment_author'];
  }
}
