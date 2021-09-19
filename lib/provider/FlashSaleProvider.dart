import 'package:flutter/foundation.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'dart:convert';
import 'package:nyoba/services/FlashSaleAPI.dart';
import 'package:nyoba/models/FlashSaleModel.dart';
import 'dart:developer';

class FlashSaleProvider with ChangeNotifier {
  FlashSaleModel flashSale;
  bool loading = true;
  List<FlashSaleModel> flashSales = [];
  List<ProductModel> flashSaleProducts = [];

  FlashSaleProvider() {
    // fetchFlashSale();
  }

  Future<bool> fetchFlashSale() async {
    loading = true;
    await FlashSaleAPI().fetchHomeFlashSale().then((data) async {
      var startTime = DateTime.now();
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          flashSales.add(FlashSaleModel.fromJson(item));
        }
        if (flashSales.isNotEmpty) {
          await FlashSaleAPI()
              .fetchFlashSaleProducts(flashSales[0].products)
              .then((data) {
            if (data.statusCode == 200) {
              print('Success');
              final responseJson = json.decode(data.body);
              flashSaleProducts.clear();
              for (Map item in responseJson) {
                flashSaleProducts.add(ProductModel.fromJson(item));
              }
              loading = false;
              notifyListeners();
              var currentTime = DateTime.now();
              var diff = currentTime.difference(startTime).inSeconds;
              log(startTime.toString(), name: 'Start');
              log(currentTime.toString(), name: 'End');

              log('${diff.toString()} Seconds', name: 'Exec Time');
            } else {
              print('Failed');
              loading = false;
              notifyListeners();
            }
          });
        } else {
          print('Failed');
          loading = false;
          notifyListeners();
        }
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }
}
