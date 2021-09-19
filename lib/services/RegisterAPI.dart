import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';

class RegisterAPI {
  register(String firstName, String lastName, String email, String username,
      String password) async {
    Map data = {
      "user_email": email,
      "user_login": username,
      "username": username,
      "user_pass": password,
      "email": email,
      "first_name": firstName,
      "last_name": lastName
    };
    var response = await baseAPI.postAsync(
      '$signUp',
      data,
      isCustom: true,
    );
    return response;
  }
}
