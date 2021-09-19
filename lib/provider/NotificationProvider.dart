import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/NotificationModel.dart';
import 'package:nyoba/services/NotificationAPI.dart';
import 'package:nyoba/utils/utility.dart';

class NotificationProvider with ChangeNotifier {
  bool isLoading = false;
  List<NotificationModel> notification = [];

  Future<List> fetchNotifications({status, search}) async {
    isLoading = !isLoading;
    var result;
    await NotificationAPI().notification().then((data) {
      result = data;
      notification.clear();
      printLog(result.toString());

      for (Map item in result) {
        notification.add(NotificationModel.fromJson(item));
      }

      isLoading = !isLoading;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }
}
