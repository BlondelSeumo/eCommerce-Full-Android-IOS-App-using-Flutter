import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/models/CartModel.dart';
import 'package:nyoba/models/OrderModel.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/services/OrderAPI.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/webview/CheckoutWebView.dart';
import 'package:provider/provider.dart';

import '../AppLocalizations.dart';
import 'CouponProvider.dart';

class OrderProvider with ChangeNotifier {
  ProductModel productDetail;
  String status;
  String search;

  bool isLoading = false;
  bool loadDataOrder = false;

  List<OrderModel> listOrder = [];

  List<ProductModel> listProductOrder = [];

  OrderModel detailOrder;

  Future checkout(order) async {
    var result;
    await OrderAPI().checkoutOrder(order).then((data) {
      printLog(data, name: 'Link Order From API');
      result = data;
    });
    return result;
  }

  Future<List> fetchOrders({status, search, orderId}) async {
    isLoading = true;
    var result;
    await OrderAPI().listMyOrder(status, search, orderId).then((data) {
      result = data;
      listOrder.clear();

      printLog(result.toString());

      for (Map item in result) {
        listOrder.add(OrderModel.fromJson(item));
      }

      listOrder.forEach((element) {
        element.productItems.sort((a, b) => b.image.compareTo(a.image));
      });

      isLoading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<List> fetchDetailOrder(orderId) async {
    isLoading = true;
    var result;
    await OrderAPI().detailOrder(orderId).then((data) {
      result = data;
      printLog(result.toString());

      for (Map item in result) {
        detailOrder = OrderModel.fromJson(item);
      }

      isLoading = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<int> loadCartCount() async {
    print('Load Count');
    List<ProductModel> productCart = [];
    int _count = 0;

    if (Session.data.containsKey('cart')) {
      List listCart = await json.decode(Session.data.getString('cart'));

      productCart = listCart
          .map((product) => new ProductModel.fromJson(product))
          .toList();

      productCart.forEach((element) {
        _count += element.cartQuantity;
      });
    }
    return _count;
  }

  Future checkOutOrder(context,
      {int totalSelected,
      List<ProductModel> productCart,
      Future<dynamic> Function() removeOrderedItems}) async {
    final coupons = Provider.of<CouponProvider>(context, listen: false);
    if (totalSelected == 0) {
      snackBar(context, message: "Please select the product first.");
    } else {
      if (Session.data.getBool('isLogin')) {
        CartModel cart = new CartModel();
        cart.listItem = [];
        productCart.forEach((element) {
          if (element.isSelected) {
            cart.listItem.add(new CartProductItem(
                productId: element.id,
                quantity: element.cartQuantity,
                variationId: element.variantId));
          }
        });

        //init list coupon
        cart.listCoupon = [];
        //check coupon
        if (coupons.couponUsed != null) {
          cart.listCoupon.add(new CartCoupon(code: coupons.couponUsed.code));
        }

        //add to cart model
        cart.paymentMethod = "xendit_bniva";
        cart.paymentMethodTitle = "Bank Transfer - BNI";
        cart.setPaid = true;
        cart.customerId = Session.data.getInt('id');
        cart.status = 'completed';
        cart.token = Session.data.getString('cookie');

        //Encode Json
        final jsonOrder = json.encode(cart);
        printLog(jsonOrder, name: 'Json Order');

        //Convert Json to bytes
        var bytes = utf8.encode(jsonOrder);

        //Convert bytes to base64
        var order = base64.encode(bytes);

        //Generate link WebView checkout
        await Provider.of<OrderProvider>(context, listen: false)
            .checkout(order)
            .then((value) async {
          printLog(value, name: 'Link Order');
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutWebView(
                        url: value,
                        onFinish: removeOrderedItems,
                      )));
        });
      } else {
        snackBar(context, message: "You should login first.");
      }
    }
  }

  Future buyNow(context, ProductModel product,
      Future<dynamic> Function() onFinishBuyNow) async {
    if (Session.data.getBool('isLogin')) {
      CartModel cart = new CartModel();
      cart.listItem = [];
      cart.listItem.add(new CartProductItem(
          productId: product.id,
          quantity: product.cartQuantity,
          variationId: product.variantId));

      //init list coupon
      cart.listCoupon = [];

      //add to cart model
      cart.paymentMethod = "xendit_bniva";
      cart.paymentMethodTitle = "Bank Transfer - BNI";
      cart.setPaid = true;
      cart.customerId = Session.data.getInt('id');
      cart.status = 'completed';
      cart.token = Session.data.getString('cookie');

      //Encode Json
      final jsonOrder = json.encode(cart);
      printLog(jsonOrder, name: 'Json Order');

      //Convert Json to bytes
      var bytes = utf8.encode(jsonOrder);

      //Convert bytes to base64
      var order = base64.encode(bytes);

      //Generate link WebView checkout
      await Provider.of<OrderProvider>(context, listen: false)
          .checkout(order)
          .then((value) async {
        printLog(value, name: 'Link Order');
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CheckoutWebView(
                      url: value,
                      onFinish: onFinishBuyNow,
                    )));
      });
    } else {
      Navigator.pop(context);
      snackBar(context, message: "You should login first.");
    }
  }

  Future loadItemOrder(context) async {
    loadDataOrder = true;
    if (detailOrder != null) {
      listProductOrder.clear();
      detailOrder.productItems.forEach((element) async {
        await Provider.of<ProductProvider>(context, listen: false)
            .fetchProductDetail(element.productId.toString())
            .then((value) {
          listProductOrder.add(value);
        });
      });
      loadDataOrder = false;
    }
  }

  Future<void> actionBuyAgain(context) async {
    detailOrder.productItems.forEach((elementOrder) {
      listProductOrder.forEach((element) {
        if (element.id == elementOrder.productId) {
          print('${element.id} == ${elementOrder.productId}');
          element.cartQuantity = elementOrder.quantity;
          element.variantId = elementOrder.variationId;
          element.priceTotal =
              double.parse(element.productPrice) * element.cartQuantity;
          element.attributes.forEach((elementAttr) {
            elementOrder.metaData.forEach((elementMeta) {
              if (elementAttr.name.toLowerCase().replaceAll(" ", "-") == elementMeta.key) {
                elementAttr.selectedVariant = elementMeta.value;
              }
            });
          });
        }
      });
    });
    for (int i = 0; i < listProductOrder.length; i++) {
      await addCart(listProductOrder[i], context);
    }
    snackBar(context, message: AppLocalizations.of(context)
        .translate('add_cart_message'));
  }

  /*add to cart*/
  Future addCart(ProductModel product, context) async {
    /*check sharedprefs for cart*/
    if (!Session.data.containsKey('cart')) {
      List<ProductModel> listCart = [];

      listCart.add(product);

      await Session.data.setString('cart', json.encode(listCart));
    } else {
      List products = await json.decode(Session.data.getString('cart'));

      printLog(products.length.toString());
      printLog(products.toString(), name: 'Cart Product');

      List<ProductModel> listCart =
          products.map((product) => ProductModel.fromJson(product)).toList();

      printLog(listCart.toString(), name: 'List Cart');

      int index = products.indexWhere((prod) =>
          prod["id"] == product.id && prod["variant_id"] == product.variantId);

      if (index != -1) {
        product.cartQuantity =
            listCart[index].cartQuantity + product.cartQuantity;

        listCart[index] = product;

        await Session.data.setString('cart', json.encode(listCart));
      } else {
        listCart.add(product);
        await Session.data.setString('cart', json.encode(listCart));
      }
    }
  }
}
