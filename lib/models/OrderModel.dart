class OrderModel {
  int id;
  String orderKey,
      currency,
      status,
      dateCreated,
      dateModified,
      discountTotal = "0",
      shippingTotal,
      total,
      customerNote,
      paymentMethodTitle,
      paymentDescription,
      transactionId,
      datePaid,
      dateCompleted;

  BillingInfo billingInfo;
  ShippingInfo shippingInfo;
  List<ProductItems> productItems = [];
  List<ShippingServices> shippingServices = [];
  List<Coupons> coupons = [];

  OrderModel(
      {this.id,
      this.orderKey,
      this.currency,
      this.status,
      this.dateCreated,
      this.dateModified,
      this.discountTotal,
      this.shippingTotal,
      this.total,
      this.customerNote,
      this.paymentMethodTitle,
      this.paymentDescription,
      this.transactionId,
      this.datePaid,
      this.dateCompleted,
      this.billingInfo,
      this.shippingInfo,
      this.productItems,
      this.shippingServices,
      this.coupons});

  Map toJson() => {
        'id': id,
        'order_key': orderKey,
        'currency': currency,
        'status': status,
        'date_created': dateCreated,
        'date_modified': dateModified,
        'discount_total': discountTotal,
        'shipping_total': shippingTotal,
        'total': total,
        'customer_note': customerNote,
        'payment_method_title': paymentMethodTitle,
        'payment_description': paymentDescription,
        'transaction_id': transactionId,
        'date_paid': datePaid,
        'date_completed': dateCompleted,
        'billing': billingInfo,
        'shipping': shippingInfo,
        'line_items': productItems,
        'shipping_lines': shippingServices,
        'coupon_lines': coupons,
      };

  OrderModel.fromJson(Map json) {
    id = json['id'];
    orderKey = json['order_key'];
    currency = json['currency'];
    status = json['status'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    shippingTotal = json['shipping_total'];
    customerNote = json['customer_note'];
    paymentMethodTitle = json['payment_method_title'];
    paymentDescription = json['payment_description'];
    transactionId = json['transaction_id'];
    datePaid = json['date_paid'];
    dateCompleted = json['date_completed'];
    billingInfo = BillingInfo.fromJson(json['billing']);
    shippingInfo = ShippingInfo.fromJson(json['shipping']);
    if (json['line_items'] != null) {
      productItems = [];
      double tempTotal = 0;
      json['line_items'].forEach((v) {
        productItems.add(new ProductItems.fromJson(v));
        tempTotal += double.parse(v['subtotal']);
      });
      tempTotal += double.parse(shippingTotal);
      total = tempTotal.toString();
    }
    if (json['shipping_lines'] != null) {
      shippingServices = [];
      json['shipping_lines'].forEach((v) {
        shippingServices.add(new ShippingServices.fromJson(v));
      });
    }
    if (json['coupon_lines'] != null) {
      coupons = [];
      double totalDiscountTemp = 0;
      json['coupon_lines'].forEach((v) {
        coupons.add(new Coupons.fromJson(v));
        totalDiscountTemp += double.parse(v['discount']);
      });
      discountTotal = totalDiscountTemp.toString();
    }
  }
}

class BillingInfo {
  String firstName,
      lastName,
      company,
      firstAddress,
      secondAddress,
      city,
      state,
      postCode,
      country,
      email,
      phone;

  BillingInfo(
      {this.firstName,
      this.lastName,
      this.company,
      this.firstAddress,
      this.secondAddress,
      this.city,
      this.state,
      this.postCode,
      this.country,
      this.email,
      this.phone});

  Map toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'company': company,
        'address_1': firstAddress,
        'address_2': secondAddress,
        'city': city,
        'state': state,
        'postcode': postCode,
        'country': country,
        'email': email,
        'phone': phone,
      };

  BillingInfo.fromJson(Map json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    firstAddress = json['address_1'];
    secondAddress = json['address_2'];
    city = json['city'];
    state = json['state'];
    postCode = json['postcode'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
  }
}

class ShippingInfo {
  String firstName,
      lastName,
      company,
      firstAddress,
      secondAddress,
      city,
      state,
      postCode,
      country;

  ShippingInfo({
    this.firstName,
    this.lastName,
    this.company,
    this.firstAddress,
    this.secondAddress,
    this.city,
    this.state,
    this.postCode,
    this.country,
  });

  Map toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'company': company,
        'address_1': firstAddress,
        'address_2': secondAddress,
        'city': city,
        'state': state,
        'postcode': postCode,
        'country': country,
      };

  ShippingInfo.fromJson(Map json) {
    firstAddress = json['first_name'];
    secondAddress = json['last_name'];
    company = json['company'];
    firstAddress = json['address_1'];
    secondAddress = json['address_2'];
    city = json['city'];
    state = json['state'];
    postCode = json['postcode'];
    country = json['country'];
  }
}

class ProductItems {
  int id, quantity, productId, price, variationId;
  String productName, subTotal, subTotalTax, total, totalTax, sku, image;
  List<MetaData> metaData;

  ProductItems(
      {this.id,
      this.quantity,
      this.productId,
      this.price,
      this.productName,
      this.subTotal,
      this.subTotalTax,
      this.total,
      this.totalTax,
      this.sku,
      this.image,
      this.variationId,
      this.metaData});

  Map toJson() => {
        'id': id,
        'name': productName,
        'product_id': productId,
        'quantity': quantity,
        'subtotal': subTotal,
        'subtotal_tax': subTotalTax,
        'total': total,
        'total_tax': totalTax,
        'sku': sku,
        'price': price,
        'image': image,
        'variation_id': variationId,
        'meta_data': metaData,
      };

  ProductItems.fromJson(Map json) {
    id = json['id'];
    productName = json['name'];
    productId = json['product_id'];
    quantity = json['quantity'];
    subTotal = json['subtotal'];
    subTotalTax = json['subtotal_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    sku = json['sku'];
    price = json['price'].toInt();
    image = json['image'] ?? "";
    variationId = json['variation_id'];
    if (json['meta_data'] != null) {
      metaData = [];
      json['meta_data'].forEach((v) {
        metaData.add(new MetaData.fromJson(v));
      });
    }
  }
}

class ShippingServices {
  int id;
  String serviceName, total, totalTax, estDay;

  ShippingServices(
      {this.id, this.serviceName, this.total, this.totalTax, this.estDay});

  Map toJson() => {
        'id': id,
        'method_title': serviceName,
        'total': total,
        'total_tax': totalTax,
        'etd': estDay,
      };

  ShippingServices.fromJson(Map json) {
    id = json['id'];
    serviceName = json['method_title'];
    total = json['total'];
    totalTax = json['total_tax'];
  }
}

class Coupons {
  int id;
  String code, discount, discountTax;

  Coupons({this.id, this.code, this.discount, this.discountTax});

  Map toJson() => {
        'id': id,
        'code': code,
        'discount': discount,
        'discount_tax': discountTax,
      };

  Coupons.fromJson(Map json) {
    id = json['id'];
    code = json['code'];
    discount = json['discount'];
    discountTax = json['discount_tax'];
  }
}

class MetaData {
  int id;
  String key, value;

  MetaData({this.id, this.key, this.value});

  Map toJson() => {
        'id': id,
        'key': key,
        'value': value,
      };

  MetaData.fromJson(Map json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }
}
