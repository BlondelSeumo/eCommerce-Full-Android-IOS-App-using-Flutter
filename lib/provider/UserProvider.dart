import 'package:flutter/foundation.dart';
import 'package:nyoba/models/PointModel.dart';
import 'package:nyoba/models/UserModel.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/services/UserAPI.dart';
import 'package:nyoba/utils/utility.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = new UserModel();

  UserModel get user => _user;

  bool loading = false;

  PointModel point;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchUserDetail() async {
    loading = true;
    var result;
    await UserAPI().fetchDetail().then((data) {
      result = data;
      printLog(result.toString());

      UserModel userModel = UserModel.fromJson(result['user']);
      if (result['poin'] != null) {
        point = PointModel.fromJson(result['poin']);
      }
      Session().saveUser(userModel, Session.data.getString('cookie'));

      this.setUser(userModel);

      print(point.toString());
      loading = false;
      notifyListeners();
    });
    loading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> updateUser(
      {String firstName,
      String lastName,
      String username,
      String password,
      String oldPassword}) async {
    loading = true;
    var result;
    await UserAPI()
        .updateUserInfo(
            firstName: firstName,
            lastName: lastName,
            password: password,
            oldPassword: oldPassword)
        .then((data) {
      result = data;
      printLog(result.toString());

      if (result['is_success'] == true) {
        Session.data.setString('cookie', result['cookie']);
      }

      loading = false;
      notifyListeners();
    });
    return result;
  }
}
