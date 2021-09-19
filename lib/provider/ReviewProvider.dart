import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/ReviewModel.dart';
import 'package:nyoba/services/ReviewAPI.dart';
import 'package:nyoba/utils/utility.dart';

class ReviewProvider with ChangeNotifier {

  bool isLoading = false;
  bool isLoadingReview = false;

  List<ReviewHistoryModel> listHistory = [];
  List<ReviewHistoryModel> listReviewLimit = [];

  List<ReviewHistoryModel> listReviewAllStar = [];
  List<ReviewHistoryModel> listReviewFiveStar = [];
  List<ReviewHistoryModel> listReviewFourStar = [];
  List<ReviewHistoryModel> listReviewThreeStar = [];
  List<ReviewHistoryModel> listReviewTwoStar = [];
  List<ReviewHistoryModel> listReviewOneStar = [];


  Future<List> fetchHistoryReview() async {
    isLoading = !isLoading;
    var result;
    await ReviewAPI().historyReview().then((data) {
      result = data;

      listHistory.clear();

      printLog(result.toString());

      for (Map item in result) {
        listHistory.add(ReviewHistoryModel.fromJson(item));
      }

      isLoading = !isLoading;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<List> fetchReviewProductLimit(productId) async {
    isLoadingReview = true;
    var result;
    await ReviewAPI().limitReview(productId).then((data) {
      result = data;

      listReviewLimit.clear();

      printLog(result.toString());

      for (Map item in result) {
        listReviewLimit.add(ReviewHistoryModel.fromJson(item));
      }

      isLoadingReview = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<List> fetchReviewProduct(productId) async {
    isLoadingReview = true;
    listReviewAllStar.clear();
    listReviewOneStar.clear();
    listReviewTwoStar.clear();
    listReviewThreeStar.clear();
    listReviewFourStar.clear();
    listReviewFiveStar.clear();
    var result;
    await ReviewAPI().productReview(productId).then((data) {
      result = data;
      printLog(result.toString());

      for (Map item in result) {
        listReviewAllStar.add(ReviewHistoryModel.fromJson(item));
      }

      listReviewAllStar.forEach((element) {
        if (int.parse(element.star) == 5) {
          listReviewFiveStar.add(element);
        } else if (int.parse(element.star) == 4) {
          listReviewFourStar.add(element);
        } else if (int.parse(element.star) == 3) {
          listReviewThreeStar.add(element);
        } else if (int.parse(element.star) == 2) {
          listReviewTwoStar.add(element);
        } else if (int.parse(element.star) == 1) {
          listReviewOneStar.add(element);
        }
      });

      isLoadingReview = false;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }
}
