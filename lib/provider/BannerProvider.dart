import 'package:flutter/foundation.dart';
import 'package:nyoba/models/BannerMiniModel.dart';
import 'package:nyoba/models/BannerModel.dart';
import 'dart:convert';
import 'package:nyoba/services/BannerAPI.dart';

class BannerProvider with ChangeNotifier {
  //Provider
  BannerModel bannerModel;
  String errorMessage;

  bool loading = true;
  bool loadingBlog = true;

  List<BannerModel> banners = [];
  List<BannerMiniModel> bannerSpecial = [];
  List<BannerMiniModel> bannerLove = [];

  BannerMiniModel bannerBlog = new BannerMiniModel();

  BannerProvider() {
    fetchBannerBlog('true');
  }

  Future<bool> fetchBanner() async {
    await BannerAPI().fetchBanner().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          banners.add(BannerModel.fromJson(item));
        }
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchBannerMini() async {
    await BannerAPI().fetchMiniBanner().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        bannerSpecial.clear();
        bannerLove.clear();
        for (Map item in responseJson) {
          if (item['type'] == 'Special Promo') {
            bannerSpecial.add(BannerMiniModel.fromJson(item));
          } else if (item['type'] == 'Love These Items') {
            bannerLove.add(BannerMiniModel.fromJson(item));
          }
        }
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchBannerBlog(String blog) async {
    await BannerAPI().fetchMiniBanner(isBlog: blog).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          if (blog == 'true') {
            bannerBlog = BannerMiniModel.fromJson(item);
          }
        }
        loadingBlog = false;
        notifyListeners();
      } else {
        loadingBlog = false;
        notifyListeners();
      }
    });
    return true;
  }
}
