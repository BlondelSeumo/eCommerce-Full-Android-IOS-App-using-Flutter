import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';

class LoginAPI {
  loginByDefault(String username, String password) async {
    Map data = {'username': username, 'password': password};
    var response = await baseAPI.postAsync(
      '$loginDefault',
      data,
      isCustom: true,
    );
    return response;
  }

  loginByOTP(phone) async {
    var response =
        await baseAPI.getAsync('$signInOTP?phone=$phone', isCustom: true);
    return response;
  }

  loginByGoogle(token) async {
    var response = await baseAPI.getAsync('$signInGoogle?access_token=$token',
        isCustom: true);
    return response;
  }

  loginByFacebook(token) async {
    var response = await baseAPI.getAsync('$signInFacebook?access_token=$token',
        isCustom: true);
    return response;
  }

  inputTokenAPI() async {
    Map data = {
      'token': Session.data.getString('device_token'),
      'cookie': Session.data.getString('cookie')
    };
    printLog(data.toString(), name: 'Token Firebase');
    var response = await baseAPI.postAsync(
      '$inputTokenUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  forgotPasswordAPI(String email) async {
    Map data = {'email': email};
    var response = await baseAPI.postAsync(
      '$forgotPasswordUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
