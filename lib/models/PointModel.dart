class PointModel {
  int pointsBalance, totalRows, page, count;
  String pointsLabel;
  List<Events> events;

  PointModel({
    this.pointsBalance,
    this.totalRows,
    this.page,
    this.count,
    this.pointsLabel,
  });

  Map toJson() => {
        'points_balance': pointsBalance,
        'total_rows': totalRows,
        'page': page,
        'count': count,
        'points_label': pointsBalance,
        'events': events
      };

  PointModel.fromJson(Map json) {
    pointsBalance = json['points_balance'];
    totalRows = json['total_rows'];
    page = json['page'];
    count = json['count'];
    pointsLabel = json['points_label'];
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events.add(new Events.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'PointModel{pointsBalance: $pointsBalance, totalRows: $totalRows, page: $page, count: $count, pointsLabel: $pointsLabel, events: $events}';
  }
}

class Events {
  String id,
      userId,
      points,
      type,
      userPointsId,
      orderId,
      adminUserId,
      discountCode,
      date,
      dateDisplayHuman,
      dateDisplay,
      description;
  var discountAmount;

  Events(
      {this.id,
      this.userId,
      this.points,
      this.type,
      this.userPointsId,
      this.orderId,
      this.adminUserId,
      this.discountCode,
      this.date,
      this.dateDisplayHuman,
      this.dateDisplay,
      this.description,
      this.discountAmount});

  Map toJson() => {
        'id': id,
        'user_id': userId,
        'points': points,
        'type': type,
        'user_points_id': userPointsId,
        'order_id': orderId,
        'admin_user_id': adminUserId,
        'discount_code': discountCode,
        'date': date,
        'date_display_human': dateDisplayHuman,
        'date_display': dateDisplay,
        'description': description,
        'discount_amount': discountAmount
      };

  Events.fromJson(Map json) {
    id = json['id'];
    userId = json['user_id'];
    points = json['points'].toString().startsWith("-")
        ? json['points']
        : json['points'].toString().replaceFirst("", "+");
    type = json['type'];
    userPointsId = json['user_points_id'];
    orderId = json['order_id'];
    adminUserId = json['admin_user_id'];
    discountCode = json['data'] != null ? json['data']['discount_code'] : "-";
    date = json['date'];
    dateDisplayHuman = json['date_display_human'];
    dateDisplay = json['date_display'];
    description = json['description'];
    discountAmount =
        json['data'] != null ? json['data']['discount_amount'] : "";
  }
}
