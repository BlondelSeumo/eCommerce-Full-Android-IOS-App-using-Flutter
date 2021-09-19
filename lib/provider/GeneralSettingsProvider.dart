import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/GeneralSettingsModel.dart';
import 'dart:convert';
import 'package:nyoba/services/GeneralSettingsAPI.dart';
import 'package:nyoba/utils/utility.dart';

class GeneralSettingsProvider with ChangeNotifier {
  List<GeneralSettingsModel> intro = [];

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

  bool loading = false;
  bool isBarcodeActive = false;
  String message;

  GeneralSettingsProvider() {
    fetchGeneralSettings();
  }

  Future<Map<String, dynamic>> fetchIntroPage() async {
    Map<String, dynamic> appConfig;
    try {
      loading = true;
      await GeneralSettingsAPI().introPageData().then((data) {
        if (data.statusCode == 200) {
          final responseJson = json.decode(data.body);

          appConfig = responseJson;
          splashscreen =
              GeneralSettingsModel.fromJson(responseJson['splashscreen']);
          for (Map item in responseJson['intro']) {
            intro.add(GeneralSettingsModel.fromJson(item));
          }
          loading = false;
          notifyListeners();
        } else {
          loading = false;
          notifyListeners();
        }
      });
      return appConfig;
    } catch(e){
      printLog(e.toString());
      return appConfig;
    }
  }

  Future<bool> fetchGeneralSettings() async {
    loading = true;
    await GeneralSettingsAPI().generalSettingsData().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson['empty_image']) {
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

        logo = GeneralSettingsModel.fromJson(responseJson['logo']);
        wa = GeneralSettingsModel.fromJson(responseJson['wa']);
        sms = GeneralSettingsModel.fromJson(responseJson['sms']);
        phone = GeneralSettingsModel.fromJson(responseJson['phone']);
        about = GeneralSettingsModel.fromJson(responseJson['about']);
        currency = GeneralSettingsModel.fromJson(responseJson['currency']);
        formatCurrency =
            GeneralSettingsModel.fromJson(responseJson['format_currency']);
        privacy = GeneralSettingsModel.fromJson(responseJson['privacy_policy']);

        if (responseJson['barcode_active'] != null){
          isBarcodeActive = responseJson['barcode_active'];
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
}
