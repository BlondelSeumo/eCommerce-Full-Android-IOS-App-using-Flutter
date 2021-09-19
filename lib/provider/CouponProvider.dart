import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/CouponModel.dart';
import 'dart:convert';
import 'package:nyoba/services/CouponAPI.dart';

class CouponProvider with ChangeNotifier {

  bool loading = false;
  bool loadingUse = false;

  List<CouponModel> coupons = [];
  List<CouponModel> couponSearched = [];

  CouponModel couponUsed;


  String searchCoupon;
  int currentPage;

  Future<void> fetchCoupon({page}) async {
    try{
      loading = true;
      currentPage = page;
      await CouponAPI().fetchListCoupon(page).then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);
          coupons.clear();
          for (Map item in responseJson) {
            DateTime exp = DateTime.now();
            if (item['date_expires'] != null){
              exp = DateTime.parse(item['date_expires']);
            }
            if (exp.isAfter(DateTime.now()) || item['date_expires'] == null)
              coupons.add(CouponModel.fromJson(item));
          }
          loading = false;
          notifyListeners();
        } else {
          coupons.clear();
          loading = false;
          notifyListeners();
        }
      });
    }catch(e){
      coupons.clear();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> useCoupon({search}) async {
    searchCoupon = search;
    CouponModel _couponUsed;
    print(loadingUse);
    await CouponAPI().searchCoupon(search).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        couponSearched.clear();
        for (Map item in responseJson) {
           couponSearched.add(CouponModel.fromJson(item));
        }

        if (couponSearched.isNotEmpty){
          _couponUsed = couponSearched[0];
        }

        couponUsed = _couponUsed;

        print(couponUsed.toString());
        loadingUse = false;
        notifyListeners();
      } else {
        couponSearched.clear();

        loadingUse = false;
        notifyListeners();
      }
    });
  }
}
