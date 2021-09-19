class NotificationModel {
  int userId, orderId;
  String status, createdAt, image;

  NotificationModel({this.userId, this.orderId, this.status, this.createdAt});

  Map toJson() => {
    'user_id': userId,
    'order_id': orderId,
    'status': status,
    'created_at': createdAt,
    'image': image,
  };

  NotificationModel.fromJson(Map json) {
    userId = json['user_id'];
    orderId = json['order_id'];
    status = json['status'];
    createdAt = json['created_at'];
    image = json['image'];
  }
}