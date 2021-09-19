import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';

class ReviewAPI {
  historyReview() async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$historyReviewUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  inputReview(productId, review, rating) async {
    Map data = {
      "product_id": productId,
      "comments": review,
      "cookie": Session.data.getString('cookie'),
      "rating": rating,
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$addReviewUrl',
      data,
      isCustom: true
    );
    return response;
  }

  limitReview(productId) async {
    Map data = {
      "post_id": productId,
      "page": "0",
      "limit": "1",
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$historyReviewUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  productReview(productId) async {
    Map data = {
      "post_id": productId,
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$historyReviewUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
