import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';

class GeneralSettingsAPI {
  introPageData() async {
    var response = await baseAPI.getAsync(
      '$introPage',
      isCustom: true,
    );
    return response;
  }

  generalSettingsData() async {
    var response = await baseAPI.getAsync(
      '$generalSetting',
      isCustom: true,
    );
    return response;
  }
}
