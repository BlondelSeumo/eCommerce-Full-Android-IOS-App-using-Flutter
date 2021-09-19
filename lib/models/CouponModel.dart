class CouponModel {
  int id;
  String code,
      amount,
      dateCreated,
      dateModified,
      discountType,
      description,
      dateExpires,
      minAmount,
      maxAmount;

  CouponModel({
      this.id,
      this.code,
      this.amount,
      this.dateCreated,
      this.dateModified,
      this.discountType,
      this.description,
      this.dateExpires,
      this.minAmount,
      this.maxAmount});

  Map toJson() => {
    'id': id,
    'code': code,
    'amount': amount,
    'date_created': dateCreated,
    'date_modified': dateModified,
    'discount_type': discountType,
    'description': description,
    'date_expires': dateExpires,
    'min_amount': minAmount,
    'max_amount': maxAmount,
  };

  CouponModel.fromJson(Map json) {
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    discountType = json['discount_type'];
    description = json['description'];
    dateExpires = json['date_expires'];
    minAmount = json['min_amount'];
    maxAmount = json['max_amount'];
  }

  @override
  String toString() {
    return 'CouponModel{id: $id, code: $code, amount: $amount, dateCreated: $dateCreated, dateModified: $dateModified, discountType: $discountType, description: $description, dateExpires: $dateExpires, minAmount: $minAmount, maxAmount: $maxAmount}';
  }
}
