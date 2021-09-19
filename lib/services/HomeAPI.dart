import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';

class HomeAPI {
  homeDataApi() async {
    var response = await baseAPI.getAsync('$homeUrl', isCustom: true);
    return response;
  }
}
