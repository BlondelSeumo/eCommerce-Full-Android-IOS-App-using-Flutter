import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/services/ProductAPI.dart';
import 'package:nyoba/services/WishlistAPI.dart';
import 'package:nyoba/utils/utility.dart';

import '../AppLocalizations.dart';

class WishlistProvider with ChangeNotifier {
  bool loadingWishlist = true;

  String message;

  List<ProductModel> listWishlistProduct = [];

  String productWishlist;

  Future<bool> fetchWishlistProducts(String productId) async {
    if (productId.isNotEmpty) {
      await ProductAPI().fetchProduct(include: productId).then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);

          printLog(responseJson.toString(), name: 'Wishlist');
          listWishlistProduct.clear();
          for (Map item in responseJson) {
            listWishlistProduct.add(ProductModel.fromJson(item));
          }
          loadingWishlist = false;
          notifyListeners();
        } else {
          print("Load Failed");
          loadingWishlist = false;
          notifyListeners();
        }
      });
    } else {
      loadingWishlist = false;
      notifyListeners();
    }
    return true;
  }

  Future<Map<String, dynamic>> checkWishlistProduct({productId}) async {
    var result;
    await WishlistAPI().setWishlist(productId, check: true).then((data) {
      result = data;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<Map<String, dynamic>> setWishlistProduct(context, {productId}) async {
    var result;
    await WishlistAPI().setWishlist(productId).then((data) {
      result = data;

      if (result['message'] == 'success') {
        if (result['type'] == 'add') {
          snackBar(context,
              message: AppLocalizations.of(context)
                  .translate('wishlist_add_message'));
        } else {
          snackBar(context,
              message: AppLocalizations.of(context)
                  .translate('wishlist_remove_message'));
        }
      } else {
        snackBar(context,
            message:
                AppLocalizations.of(context).translate('error_submit_message'),
            color: Colors.red);
      }

      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<Map<String, dynamic>> loadWishlistProduct({productId}) async {
    loadingWishlist = true;
    var result;
    await WishlistAPI().fetchProductWishlist().then((data) {
      result = data;
      productWishlist = result['products'];
      notifyListeners();
      printLog(result.toString(), name: "Wishlist Products");
    });
    return result;
  }
}
