import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/BannerMiniModel.dart';
import 'package:nyoba/models/BannerModel.dart';
import 'package:nyoba/models/CategoriesModel.dart';
import 'package:nyoba/models/GeneralSettingsModel.dart';
import 'package:nyoba/models/HomeModel.dart';
import 'package:nyoba/provider/CategoryProvider.dart';
import 'package:nyoba/provider/FlashSaleProvider.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/services/HomeAPI.dart';
import 'package:provider/provider.dart';

class HomeProvider with ChangeNotifier {
  bool isReload = false;
  bool loading = false;

  /*List Main Slider Banner Model*/
  List<BannerModel> banners = [];

  /*List Banner Mini Product Model*/
  List<BannerMiniModel> bannerSpecial = [];
  List<BannerMiniModel> bannerLove = [];

  /*List Home Mini Categories Model*/
  List<CategoriesModel> categories = [];

  /*List Intro Page Model*/
  List<GeneralSettingsModel> intro = [];

  /*General Settings Model*/
  GeneralSettingsModel splashscreen = new GeneralSettingsModel();
  GeneralSettingsModel logo = new GeneralSettingsModel();
  GeneralSettingsModel wa = new GeneralSettingsModel();
  GeneralSettingsModel sms = new GeneralSettingsModel();
  GeneralSettingsModel phone = new GeneralSettingsModel();
  GeneralSettingsModel about = new GeneralSettingsModel();
  GeneralSettingsModel currency = new GeneralSettingsModel();
  GeneralSettingsModel formatCurrency = new GeneralSettingsModel();
  GeneralSettingsModel privacy = new GeneralSettingsModel();
  GeneralSettingsModel image404 = new GeneralSettingsModel();
  GeneralSettingsModel imageThanksOrder = new GeneralSettingsModel();
  GeneralSettingsModel imageNoTransaction = new GeneralSettingsModel();
  GeneralSettingsModel imageSearchEmpty = new GeneralSettingsModel();
  bool isBarcodeActive = false;

  /*Flash Sales Model*/
  List<FlashSaleHomeModel> flashSales = [];

  /*Extend Product Model*/
  List<ProductExtendHomeModel> specialProducts = [];
  List<ProductExtendHomeModel> bestProducts = [];
  List<ProductExtendHomeModel> recommendationProducts = [];

  Future<void> fetchHomeData(context) async {
    await fetchFlashSale(context);
  }

  Future<void> fetchProductCategories(context) async {
    final categories = Provider.of<CategoryProvider>(context, listen: false);
    if (categories.productCategories.isEmpty) {
      await categories.fetchProductCategories();
    }
    await fetchNewProducts(context);
  }

  Future<void> fetchFlashSale(context) async {
    final flashSale = Provider.of<FlashSaleProvider>(context, listen: false);
    await flashSale.fetchFlashSale();
    await fetchProductCategories(context);
  }

  Future<void> fetchNewProducts(context) async {
    final product = Provider.of<ProductProvider>(context, listen: false);
    await product.fetchNewProducts('', page: 1);
  }

  Future<bool> fetchHome() async {
    try{
      loading = true;
      await HomeAPI().homeDataApi().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);

          /*Add Data Main Slider*/
          banners.clear();
          for (Map item in responseJson['main_slider']) {
            banners.add(BannerModel.fromJson(item));
          }
          banners = new List.from(banners.reversed);
          /*End*/

          /*Add Data Mini Categories Home*/
          categories.clear();
          for (Map item in responseJson['mini_categories']) {
            categories.add(CategoriesModel.fromJson(item));
          }
          categories = new List.from(categories.reversed);
          categories.add(new CategoriesModel(
              image: 'images/lobby/viewMore.png',
              categories: null,
              id: null,
              titleCategories: 'View More'));
          /*End*/

          /*Add Data Flash Sales Home*/
          for (Map item in responseJson['products_flash_sale']) {
            flashSales.add(FlashSaleHomeModel.fromJson(item));
          }
          /*End*/

          /*Add Data Mini Banner Home*/
          bannerSpecial.clear();
          bannerLove.clear();
          for (Map item in responseJson['mini_banner']) {
            if (item['type'] == 'Special Promo') {
              bannerSpecial.add(BannerMiniModel.fromJson(item));
            } else if (item['type'] == 'Love These Items') {
              bannerLove.add(BannerMiniModel.fromJson(item));
            }
          }
          bannerSpecial = new List.from(bannerSpecial.reversed);
          bannerLove = new List.from(bannerLove.reversed);
          /*End*/

          /*Add Data Special Products*/
          for (Map item in responseJson['products_special']) {
            specialProducts.add(ProductExtendHomeModel.fromJson(item));
          }
          /*End*/

          /*Add Data Best Products*/
          for (Map item in responseJson['products_our_best_seller']) {
            bestProducts.add(ProductExtendHomeModel.fromJson(item));
          }
          /*End*/

          /*Add Data Recommendation Products*/
          for (Map item in responseJson['products_recomendation']) {
            recommendationProducts.add(ProductExtendHomeModel.fromJson(item));
          }
          /*End*/

          /*Add Data General Settings*/
          for (Map item in responseJson['general_settings']['empty_image']) {
            if (item['title'] == '404_images') {
              image404 = GeneralSettingsModel.fromJson(item);
            } else if (item['title'] == 'thanks_order') {
              imageThanksOrder = GeneralSettingsModel.fromJson(item);
            } else if (item['title'] == 'no_transaksi') {
              imageNoTransaction = GeneralSettingsModel.fromJson(item);
            } else if (item['title'] == 'search_empty') {
              imageSearchEmpty = GeneralSettingsModel.fromJson(item);
            }
          }

          logo = GeneralSettingsModel.fromJson(responseJson['general_settings']['logo']);
          wa = GeneralSettingsModel.fromJson(responseJson['general_settings']['wa']);
          sms = GeneralSettingsModel.fromJson(responseJson['general_settings']['sms']);
          phone = GeneralSettingsModel.fromJson(responseJson['general_settings']['phone']);
          about = GeneralSettingsModel.fromJson(responseJson['general_settings']['about']);
          currency = GeneralSettingsModel.fromJson(responseJson['general_settings']['currency']);
          formatCurrency =
              GeneralSettingsModel.fromJson(responseJson['general_settings']['format_currency']);
          privacy = GeneralSettingsModel.fromJson(responseJson['general_settings']['privacy_policy']);

          if (responseJson['general_settings']['barcode_active'] != null){
            isBarcodeActive = responseJson['general_settings']['barcode_active'];
          }
          /*End*/

          /*Add Data Intro Page & Splash Screen*/
          splashscreen =
              GeneralSettingsModel.fromJson(responseJson['splashscreen']);
          for (Map item in responseJson['intro']) {
            intro.add(GeneralSettingsModel.fromJson(item));
          }
          /*End*/

          print("Completed");
          loading = false;
          notifyListeners();
        } else {
          loading = false;
          notifyListeners();
          print("Load Failed");
        }
      });
      return true;
    }catch(e){
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
