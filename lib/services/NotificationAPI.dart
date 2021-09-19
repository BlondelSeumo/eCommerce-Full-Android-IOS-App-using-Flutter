import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';

class NotificationAPI {
  notification() async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$notificationUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
