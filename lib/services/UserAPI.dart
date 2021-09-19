import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/Session.dart';

class UserAPI {
  fetchDetail() async {
    Map data = {"cookie": Session.data.get('cookie')};
    var response = await baseAPI.postAsync('$userDetail', data, isCustom: true);
    return response;
  }

  updateUserInfo(
      {String firstName,
      String lastName,
      String password,
      String oldPassword}) async {
    Map data = {
      "cookie": Session.data.get('cookie'),
      "first_name": firstName,
      "last_name": lastName,
      if (password.isNotEmpty) "user_pass": password,
      if (password.isNotEmpty) "old_pass": oldPassword
    };
    var response = await baseAPI.postAsync('$updateUser', data, isCustom: true);
    return response;
  }
}
